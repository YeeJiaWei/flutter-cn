import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fcn/src/add_command.dart';
import 'package:fcn/src/diff_command.dart';
import 'package:fcn/src/docs_command.dart';
import 'package:fcn/src/fcn_version.dart';
import 'package:fcn/src/init_command.dart';
import 'package:fcn/src/list_command.dart';
import 'package:fcn/src/upgrade_command.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.contains('--version') || arguments.contains('-v')) {
    stdout.writeln(fcnVersion);
    exit(0);
  }

  final runner = CommandRunner<int>('fcn', 'Copy flutter-snippets components into your project.')
    ..addCommand(InitCommand())
    ..addCommand(ListCommand())
    ..addCommand(AddCommand())
    ..addCommand(DiffCommand())
    ..addCommand(DocsCommand())
    ..addCommand(UpgradeCommand());

  try {
    final code = await runner.run(arguments);
    exit(code ?? 0);
  } on UsageException catch (e) {
    stderr.writeln(e);
    exit(64);
  }
}
