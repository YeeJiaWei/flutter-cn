import 'dart:io';

import 'package:args/command_runner.dart';

import 'project_config.dart';

/// `fcn init` — writes `fcn.json` for the current project.
class InitCommand extends Command<int> {
  InitCommand() {
    argParser
      ..addOption('source', help: 'The store: a local path or a git URL.')
      ..addOption('dir', help: 'Where snippets are copied to, e.g. lib/ui/snippets.');
  }

  @override
  final name = 'init';

  @override
  final description = 'Write fcn.json for this project.';

  @override
  Future<int> run() async {
    final projectRoot = Directory.current;
    var source = argResults?['source'] as String?;
    var dir = argResults?['dir'] as String?;

    if (source == null) {
      stdout.write('Store source (local path or git URL): ');
      source = stdin.readLineSync()?.trim();
    }
    if (dir == null) {
      stdout.write('Directory to copy snippets into (e.g. lib/ui/snippets): ');
      dir = stdin.readLineSync()?.trim();
    }
    if (source == null || source.isEmpty || dir == null || dir.isEmpty) {
      stderr.writeln('fcn init needs a source and a dir.');
      return 64;
    }

    ProjectConfig(source: source, dir: dir, installed: {}).save(projectRoot);
    stdout.writeln('Wrote ${ProjectConfig.file(projectRoot).path}');
    return 0;
  }
}
