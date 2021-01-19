import 'parser.dart';
import 'definition.dart';
import "lexer.dart";

class Context {
  Map<String, String> variables;

  Context() {
    variables = Map<String, String>();
  }
}

int execute(String code) {
  Context ctx = Context();

  Parser parser = Parser();
  SourceCode ast = parser.parse(code);
  return evaluate(ast, ctx);
}

int evaluate(SourceCode ast, Context ctx) {
  if (ast.statements.isEmpty) {
    return -1;
  }

  ast.statements.forEach((statement) {
    int v = evalStatement(statement, ctx);
    if (v != 0) {
      return v;
    }
  });
  return 0;
}

int evalStatement(Statement statement, Context ctx) {
  if (statement is PrintStatement) {
    return evalPrint(statement, ctx);
  } else if (statement is Assignment) {
    return evalAssignment(statement, ctx);
  } else {
    print('unknown statement $statement');
    return -1;
  }
}

int evalAssignment(Assignment statement, Context ctx) {
  ctx.variables[statement.left.name] = statement.value;
  return 0;
}

int evalPrint(PrintStatement statement, Context ctx) {
  String varName = statement.variable.name;
  if (varName.isEmpty) {
    return -1;
  }

  if (!ctx.variables.containsKey(varName)) {
    print('var \$$varName not exits');
    return -1;
  }

  print(ctx.variables[varName]);
  return 0;
}
