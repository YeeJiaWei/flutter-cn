import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import 'project_config.dart';
import 'snippet.dart';
import 'snippet_scan_exception.dart';
import 'snippet_scanner.dart';
import 'store_cache.dart';

/// `fcn list` — shows every snippet grouped by folder, with its symbols,
/// packages, description and whether the project already has it.
class ListCommand extends Command<int> {
  @override
  final name = 'list';

  @override
  final description = 'List the store\'s snippets.';

  @override
  Future<int> run() async {
    final projectRoot = Directory.current;
    final config = ProjectConfig.tryLoad(projectRoot);
    final home = Directory(p.join(Platform.environment['HOME'] ?? '.', '.fcn'));
    final storeRoot = config != null
        ? StoreCache(homeDir: home).resolve(config.source)
        : Directory.current;

    final List<Snippet> snippets;
    try {
      snippets = SnippetScanner().scan(storeRoot);
    } on SnippetScanException catch (e) {
      stderr.writeln(e);
      return 1;
    }
    String? currentFolder;
    for (final snippet in snippets) {
      if (snippet.folder != currentFolder) {
        currentFolder = snippet.folder;
        stdout.writeln('\n$currentFolder/');
      }
      final installedMark = config?.installed.containsKey(snippet.path) == true ? ' [installed]' : '';
      stdout.writeln('  ${snippet.baseName}$installedMark');
      if (snippet.symbols.isNotEmpty) stdout.writeln('    symbols: ${snippet.symbols.join(', ')}');
      if (snippet.packageImports.isNotEmpty) {
        stdout.writeln('    packages: ${snippet.packageImports.join(', ')}');
      }
      if (snippet.description != null) stdout.writeln('    ${snippet.description}');
    }
    return 0;
  }
}
