import 'dart:io';
import "eval.dart";

void main(List<String> argv) {
  if (argv.isEmpty) {
    print('usage: should put filename');
  }

  var file = new File(argv[0]);
  String code = file.readAsStringSync();
  int r = execute(code);
  if (r != 0) {
    print('exit $r');
  }
}
