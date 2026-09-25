import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import 'docs_checker.dart';
import 'docs_store.dart';
import 'project_config.dart';
import 'snippet.dart';
import 'snippet_lookup.dart';
import 'snippet_lookup_exception.dart';
import 'snippet_scan_exception.dart';
import 'snippet_scanner.dart';
import 'store_cache.dart';

/// `fcn docs [name]` — the component usage docs: an index of every
/// component's `use_when`/`avoid_when`, or one component's full doc.
class DocsCommand extends Command<int> {
  DocsCommand() {
    argParser
      ..addOption('source', help: 'The store: a local path or a git URL. Defaults to fcn.json, then ~/.fcn/store.')
      ..addFlag('json', help: 'Print machine-readable JSON.')
      ..addFlag('check', help: "Validate every component's doc, for CI and store maintainers.");
  }

  @override
  final name = 'docs';

  @override
  final description = "Show a component's usage doc, or the index of all of them.";

  @override
  final invocation = 'fcn docs [name]';

  @override
  Future<int> run() async {
    final projectRoot = Directory.current;
    final config = ProjectConfig.tryLoad(projectRoot);
    final storeRoot = _resolveStoreRoot(config);

    final List<Snippet> snippets;
    try {
      snippets = SnippetScanner().scan(storeRoot);
    } on SnippetScanException catch (e) {
      stderr.writeln(e);
      return 1;
    }

    final docsStore = DocsStore(storeRoot);
    final json = argResults?['json'] as bool;
    final check = argResults?['check'] as bool;

    if (check) return _runCheck(snippets, docsStore);

    final names = argResults?.rest ?? [];
    if (names.isEmpty) return _printIndex(snippets, docsStore, config, json: json);
    return _printDoc(snippets, docsStore, names.first, json: json);
  }

  Directory _resolveStoreRoot(ProjectConfig? config) {
    final home = Directory(p.join(Platform.environment['HOME'] ?? '.', '.fcn'));
    final source = argResults?['source'] as String?;
    if (source != null) return StoreCache(homeDir: home).resolve(source);
    if (config != null) return StoreCache(homeDir: home).resolve(config.source);
    return Directory(p.join(home.path, 'store'));
  }

  int _printIndex(List<Snippet> snippets, DocsStore docsStore, ProjectConfig? config, {required bool json}) {
    final entries = snippets.map((snippet) {
      final doc = docsStore.load(snippet);
      return {
        'path': snippet.path,
        'folder': snippet.folder,
        'name': snippet.baseName,
        'installed': config?.installed.containsKey(snippet.path) == true,
        'hasDoc': doc != null,
        'useWhen': doc?.frontMatter.useWhen,
        'avoidWhen': doc?.frontMatter.avoidWhen,
      };
    }).toList();

    if (json) {
      stdout.writeln(jsonEncode({'components': entries}));
      return 0;
    }

    String? currentFolder;
    for (final entry in entries) {
      final folder = entry['folder'] as String;
      if (folder != currentFolder) {
        currentFolder = folder;
        stdout.writeln('\n$folder/');
      }
      final installedMark = entry['installed'] == true ? ' [installed]' : '';
      stdout.writeln('  ${entry['name']}$installedMark');
      if (entry['hasDoc'] != true) {
        stdout.writeln('    (no doc)');
        continue;
      }
      if (entry['useWhen'] != null) stdout.writeln('    use: ${entry['useWhen']}');
      if (entry['avoidWhen'] != null) stdout.writeln('    avoid: ${entry['avoidWhen']}');
    }
    return 0;
  }

  int _printDoc(List<Snippet> snippets, DocsStore docsStore, String query, {required bool json}) {
    final Snippet snippet;
    try {
      snippet = SnippetLookup(snippets).resolve(query);
    } on SnippetLookupException catch (e) {
      stderr.writeln(e);
      return 1;
    }

    final doc = docsStore.load(snippet);
    if (doc == null) {
      if (json) {
        stdout.writeln(jsonEncode({'path': snippet.path, 'hasDoc': false}));
      } else {
        stderr.writeln('No doc for ${snippet.path} (docs/components/${snippet.folder}/${snippet.baseName}.md).');
      }
      return 1;
    }

    if (json) {
      stdout.writeln(jsonEncode({'path': snippet.path, 'hasDoc': true, 'markdown': doc.markdown}));
    } else {
      stdout.writeln(doc.markdown);
    }
    return 0;
  }

  int _runCheck(List<Snippet> snippets, DocsStore docsStore) {
    final problems = DocsChecker().check(snippets, docsStore);
    if (problems.isEmpty) {
      stdout.writeln('docs check: ${snippets.length} components, 0 problems.');
      return 0;
    }
    for (final problem in problems) {
      stdout.writeln(problem);
    }
    return 1;
  }
}
