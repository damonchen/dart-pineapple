enum TokenKind {
  EOF,
  varPrefix,
  lefParent,
  rightParent,
  quote,
  doubleQuote,
  assign,
  name,
  print,
  ignore,
}

bool debug = false;

debugLog(msg) {
  if (debug) {
    print(msg);
  }
}

bool isVarPrefix(TokenKind kind) {
  return kind == TokenKind.varPrefix;
}

bool isLeftParent(TokenKind kind) {
  return kind == TokenKind.lefParent;
}

bool isRightParent(TokenKind kind) {
  return kind == TokenKind.rightParent;
}

bool isQuote(TokenKind kind) {
  return kind == TokenKind.quote;
}

bool isDoubleQuote(TokenKind kind) {
  return kind == TokenKind.doubleQuote;
}

bool isAssign(TokenKind kind) {
  return kind == TokenKind.assign;
}

bool isName(TokenKind kind) {
  return kind == TokenKind.name;
}

bool isEof(TokenKind kind) {
  return kind == TokenKind.EOF;
}

// final tokenEOF = -1;
// final varPrefix = 0; // '\$';
// final leftParent = 1; //'\(';
// final rightParent = 2; //'\)';
// final quote = 3; //'\'';
// final doubleQuote = 4; //'\"';
// final tokenName = 5; //'name'
// final tokenPrint = 6; // print statement
// final ignoreToken = 7; // ignore, may error occur

bool isWhiteSpace(String s) {
  return (s == '\r' || s == '\n' || s == '\t' || s == ' ');
}

bool isNewLine(String s) {
  return (s == '\r' || s == '\n');
}

bool isLetter(String s) {
  bool r = true;
  List<int> codeUnits = s.codeUnits;
  int i = 0;
  for (; i < codeUnits.length; i++) {
    int unit = codeUnits[i];
    if (!((unit >= 'A'.codeUnitAt(0) && unit <= 'Z'.codeUnitAt(0)) ||
        (unit >= 'a'.codeUnitAt(0) && unit <= 'z'.codeUnitAt(0)))) {
      debugLog('i :$unit, ${'z'.codeUnitAt(0)}');
      r = false;
      break;
    }
  }
  debugLog('is letter: $r');
  return r;
}

bool isKeyword(String word) {
  List<String> keywords = ["print"];
  return keywords.contains(word);
}

class Lexer {
  String str;
  int pos;

  String tempToken;
  int line;
  int column;

  Lexer(this.str) {
    pos = 0;
    line = 1;
    column = 0;
  }

  void skipSpace() {
    int length = str.length;
    while (pos < length) {
      if (!isWhiteSpace(str[pos])) {
        return;
      }

      if (isNewLine(str[pos])) {
        line++;
        column = 0;
      }
      pos = pos + 1;
      column += 1;
    }
  }

  String scanName() {
    int start = pos;
    while (isLetter(str[pos])) {
      pos = pos + 1;
    }
    String name = str.substring(start, pos);
    debugLog('name: $name, start: $start, pos: $pos');
    return name;
  }

  String scanString(TokenKind quote) {
    int start = pos;
    String quoteValue = '\'';
    if (isDoubleQuote(quote)) {
      quoteValue = '\"';
    }
    while (str[pos] != quoteValue) {
      pos = pos + 1;
    }

    return str.substring(start, pos);
  }

  preScan() {
    int currPos = pos;
    int currLine = line;
    int currCol = column;

    TokenKind kind = nextToken();

    pos = currPos;
    line = currLine;
    column = currCol;

    return kind;
  }

  TokenKind nextToken() {
    TokenKind kind = TokenKind.ignore;
    String token;

    skipSpace();
    if (pos == str.length) {
      return TokenKind.EOF;
    }

    String prefix = str[pos];
    switch (prefix) {
      case '\$':
        kind = TokenKind.varPrefix;
        token = prefix;
        pos++;
        column++;
        break;
      case '\(':
        kind = TokenKind.lefParent;
        token = prefix;
        pos++;
        column++;
        break;
      case '\)':
        kind = TokenKind.rightParent;
        token = prefix;
        pos++;
        column++;
        break;
      case '\'':
        kind = TokenKind.quote;
        token = prefix;
        pos++;
        column++;
        break;
      case '\"':
        kind = TokenKind.doubleQuote;
        token = prefix;
        pos++;
        column++;
        break;
      case '=':
        kind = TokenKind.assign;
        token = prefix;
        pos++;
        column++;
        break;
    }

    debugLog('current token prefix $prefix');
    if (isLetter(prefix)) {
      token = scanName();
      debugLog('current token $token');
      if (isKeyword(token)) {
        kind = TokenKind.print;
      } else {
        kind = TokenKind.name;
      }
    }
    tempToken = token;
    return kind;
  }
}
