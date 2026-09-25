import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import 'project_config.dart';
import 'snippet_scan_exception.dart';
import 'store_cache.dart';
import 'store_layout.dart';

/// `fcn diff [name]` — shows `git diff --no-index` between the store's
/// current version of an installed snippet and the project's copy, or every
/// installed snippet when no name is given.
class DiffCommand extends Command<int> {
  @override
  final name = 'diff';

  @override
  final description = "Diff the project's copy against the store's current version.";

  @override
  final invocation = 'fcn diff [name]';

  @override
  Future<int> run() async {
    final projectRoot = Directory.current;
    final config = ProjectConfig.tryLoad(projectRoot);
    if (config == null) {
      stderr.writeln('No fcn.json found. Run `fcn init` first.');
      return 1;
    }

    final home = Directory(p.join(Platform.environment['HOME'] ?? '.', '.fcn'));
    final storeRoot = StoreCache(homeDir: home).resolve(config.source);

    final Directory source;
    try {
      source = componentsDir(storeRoot);
    } on SnippetScanException catch (e) {
      stderr.writeln(e);
      return 1;
    }

    final args = argResults?.rest ?? [];
    final paths = args.isEmpty
        ? config.installed.keys.toList()
        : config.installed.keys.where((path) => path.contains(args.first)).toList();

    if (paths.isEmpty) {
      stderr.writeln('No installed snippet matches "${args.isEmpty ? '' : args.first}".');
      return 1;
    }

    var anyDiffer = false;
    for (final path in paths..sort()) {
      final storeFile = File(p.joinAll([source.path, ...path.split('/')]));
      final projectFile = File(p.joinAll([projectRoot.path, config.dir, ...path.split('/')]));
      if (!projectFile.existsSync()) {
        stdout.writeln('$path: missing from ${config.dir} (never copied, or removed)');
        anyDiffer = true;
        continue;
      }
      final result = Process.runSync('git', ['diff', '--no-index', storeFile.path, projectFile.path]);
      if (result.exitCode == 0) continue;
      anyDiffer = true;
      stdout.writeln(result.stdout);
    }

    return anyDiffer ? 1 : 0;
  }
}
