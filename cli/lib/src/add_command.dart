import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import 'dependency_resolver.dart';
import 'package_installer.dart';
import 'project_config.dart';
import 'snippet_installer.dart';
import 'snippet.dart';
import 'snippet_lookup.dart';
import 'snippet_lookup_exception.dart';
import 'snippet_scan_exception.dart';
import 'snippet_scanner.dart';
import 'store_cache.dart';

/// `fcn add <name...>` — copies the requested snippets and everything they
/// import into the project, adding any pub packages they need.
class AddCommand extends Command<int> {
  AddCommand() {
    argParser
      ..addFlag('overwrite', help: 'Replace files already in the project.')
      ..addFlag('dry-run', help: 'Print what would happen without copying.')
      ..addFlag('no-pub', help: 'Skip `flutter pub add` for missing packages.');
  }

  @override
  final name = 'add';

  @override
  final description = 'Copy one or more snippets (and their dependencies) into the project.';

  @override
  final invocation = 'fcn add <name...>';

  @override
  Future<int> run() async {
    final names = argResults?.rest ?? [];
    if (names.isEmpty) {
      stderr.writeln('fcn add needs at least one snippet name.');
      return 64;
    }

    final projectRoot = Directory.current;
    final config = ProjectConfig.tryLoad(projectRoot);
    if (config == null) {
      stderr.writeln('No fcn.json found. Run `fcn init` first.');
      return 1;
    }

    final home = Directory(p.join(Platform.environment['HOME'] ?? '.', '.fcn'));
    final storeRoot = StoreCache(homeDir: home).resolve(config.source);

    final List<Snippet> snippets;
    try {
      snippets = SnippetScanner().scan(storeRoot);
    } on SnippetScanException catch (e) {
      stderr.writeln(e);
      return 1;
    }

    final lookup = SnippetLookup(snippets);
    final rootPaths = <String>[];
    for (final name in names) {
      try {
        rootPaths.add(lookup.resolve(name).path);
      } on SnippetLookupException catch (e) {
        stderr.writeln(e);
        return 1;
      }
    }

    final resolved = DependencyResolver(snippets).resolveAll(rootPaths);
    final overwrite = argResults?['overwrite'] as bool;
    final dryRun = argResults?['dry-run'] as bool;
    final noPub = argResults?['no-pub'] as bool;

    final result = SnippetInstaller(projectRoot: projectRoot, storeRoot: storeRoot, config: config)
        .install(resolved, overwrite: overwrite, dryRun: dryRun);

    for (final snippet in result.copied) {
      stdout.writeln('${dryRun ? 'would add' : 'add'}  ${config.dir}/${snippet.path}');
    }
    for (final snippet in result.skipped) {
      stdout.writeln('skip (already installed)  ${config.dir}/${snippet.path}');
    }

    if (!dryRun) {
      config.save(projectRoot);
      if (!noPub) {
        final packages = {for (final s in resolved) ...s.packageImports};
        if (packages.isNotEmpty) PackageInstaller.addMissing(projectRoot, packages);
      }
      stdout.writeln(
        '\nBind your design tokens — every colour/spacing/radius is a constructor default.',
      );
    }

    return 0;
  }
}
