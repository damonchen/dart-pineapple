import 'dart:typed_data';

class Variable {
  String name;
  int line;

  Variable(this.name, this.line);
}

class Expression {
  Variable variable;
  String str;
  int num;
  int kind;

  int line;
}

class Statement {}

class Assignment extends Statement {
  Variable left;
  String value;
  int line;
  Assignment(this.left, this.value, this.line);
}

class PrintStatement extends Statement {
  Variable variable;
  int line;

  static Object self;

  PrintStatement(this.variable, this.line);
}

class SourceCode {
  List<Statement> statements;
  int line;
}
