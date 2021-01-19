// parse string for language

import 'definition.dart';
import 'lexer.dart';

class Parser {
  String parseName(Lexer lexer) {
    TokenKind kind = lexer.nextToken();
    if (!isName(kind)) {
      debugLog('not name kind');
      return null;
    }

    return lexer.tempToken;
  }

  String parseString(Lexer lexer) {
    TokenKind kind = lexer.nextToken();
    if (!(isQuote(kind) || isDoubleQuote(kind))) {
      debugLog('not quote kind: $kind');
      return null;
    }

    bool isSingleQuote = isQuote(kind);

    String value = lexer.scanString(kind);
    debugLog('scan string value : $value');

    kind = lexer.nextToken();
    if (isSingleQuote && !isQuote(kind)) {
      debugLog('not single quote kind');
      return null;
    } else if (!isDoubleQuote(kind)) {
      debugLog('not double quote kind, $kind');
      return null;
    } else {
      return value;
    }
  }

  Variable parseVariable(Lexer lexer) {
    TokenKind kind = lexer.nextToken();
    if (!isVarPrefix(kind)) {
      debugLog('not var prefix kind');
      return null;
    }

    String name = parseName(lexer);
    return Variable(name, lexer.line);
  }

  Assignment parseAssignment(Lexer lexer) {
    Variable variable = parseVariable(lexer);
    TokenKind kind = lexer.nextToken();
    if (!isAssign(kind)) {
      debugLog('not assign kind: $kind');
      return null;
    }

    String value = parseString(lexer);
    return Assignment(variable, value, lexer.line);
  }

  PrintStatement parsePrint(Lexer lexer) {
    TokenKind token = lexer.nextToken();
    if (token != TokenKind.print) {
      debugLog('not var print kind');
      return null;
    }

    token = lexer.nextToken();
    if (!isLeftParent(token)) {
      debugLog('not left parent kind');
      return null;
    }

    Variable variable = parseVariable(lexer);

    token = lexer.nextToken();
    if (!isRightParent(token)) {
      debugLog('not right parent kind');
      return null;
    }

    PrintStatement statement = PrintStatement(variable, lexer.line);
    return statement;
  }

  List<Statement> parseStatements(Lexer lexer) {
    lexer.skipSpace();

    List<Statement> statements = List<Statement>();

    while (true) {
      TokenKind kind = lexer.preScan();
      if (kind == TokenKind.print) {
        statements.add(parsePrint(lexer));
      } else if (TokenKind.values.contains(kind) && !isEof(kind)) {
        statements.add(parseAssignment(lexer));
      } else if (isEof(kind)) {
        break;
      } else {
        print('unknown statement');
      }
    }

    return statements;
  }

  SourceCode parseCode(Lexer lexer) {
    SourceCode sourceCode = SourceCode();
    sourceCode.statements = parseStatements(lexer);
    return sourceCode;
  }

  SourceCode parse(String code) {
    Lexer lexer = Lexer(code);
    return parseCode(lexer);
  }
}
