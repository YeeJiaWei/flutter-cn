import 'dart:io';

import 'package:args/command_runner.dart';

import 'project_config.dart';

/// `fcn init` — writes `fcn.json` for the current project.
class InitCommand extends Command<int> {
  InitCommand() {
    argParser
      ..addOption(
        'source',
        help: 'A fork or local store; defaults to the store the installer cloned (~/.fcn/store).',
      )
      ..addOption('dir', help: 'Where snippets are copied to, e.g. lib/ui/snippets.');
  }

  @override
  final name = 'init';

  @override
  final description = 'Write fcn.json for this project.';

  @override
  Future<int> run() async {
    final projectRoot = Directory.current;
    final source = argResults?['source'] as String?;
    var dir = argResults?['dir'] as String?;

    if (dir == null && stdin.hasTerminal) {
      stdout.write('Directory to copy snippets into (e.g. lib/ui/snippets): ');
      dir = stdin.readLineSync()?.trim();
    }
    if (dir == null || dir.isEmpty) {
      dir = 'lib/ui';
      stdout.writeln('No --dir given, defaulting to $dir');
    }

    ProjectConfig(source: source, dir: dir, installed: {}).save(projectRoot);
    stdout.writeln('Wrote ${ProjectConfig.file(projectRoot).path}');
    stdout.writeln('  source: ${source ?? '~/.fcn/store (default)'}');
    stdout.writeln('  dir: $dir');
    return 0;
  }
}
