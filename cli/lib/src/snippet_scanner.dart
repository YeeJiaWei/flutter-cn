import 'dart:io';

import 'package:path/path.dart' as p;

import 'snippet.dart';
import 'snippet_scan_exception.dart';
import 'store_layout.dart';

/// Scans the store's `components/` folders and parses each file with regex,
/// no analyzer dependency and no registry file to keep in sync.
class SnippetScanner {
  static const excludedDirs = {'build', '.dart_tool'};

  static final _importRegex =
      RegExp(r"""^import\s+'([^']+)';""", multiLine: true);
  static final _declRegex = RegExp(
      r'^(?:(?:abstract|base|final|interface|sealed|mixin)\s+)*(?:class|enum|mixin|extension)\s+([A-Za-z_]\w*)',
      multiLine: true);
  static final _typedefRegex =
      RegExp(r'^typedef\s+([A-Za-z_]\w*)', multiLine: true);
  static final _functionRegex = RegExp(
    r'^(?:Future<[^>]*>\??|void|[A-Za-z_]\w*(?:<[^>]*>)?\??)\s+([A-Za-z_]\w*)\s*(?:<[^>]*>)?\s*\(',
    multiLine: true,
  );

  /// Scans every `.dart` file under [storeRoot]'s `components/` directory.
  ///
  /// Throws [SnippetScanException] when [storeRoot] has no `components/`
  /// directory, or when a file's relative import resolves outside it.
  List<Snippet> scan(Directory storeRoot) {
    final root = componentsDir(storeRoot);
    final snippets = <Snippet>[];
    for (final entity in root.listSync()) {
      if (entity is! Directory) continue;
      final name = p.basename(entity.path);
      if (name.startsWith('.') || excludedDirs.contains(name)) continue;
      for (final file in _dartFilesIn(entity)) {
        snippets.add(_parse(root, file));
      }
    }
    snippets.sort((a, b) => a.path.compareTo(b.path));
    return snippets;
  }

  Iterable<File> _dartFilesIn(Directory dir) sync* {
    for (final entity in dir.listSync(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.endsWith('.dart')) yield entity;
    }
  }

  Snippet _parse(Directory storeRoot, File file) {
    final relPath = p
        .relative(file.path, from: storeRoot.path)
        .replaceAll(p.separator, '/');
    final content = file.readAsStringSync();

    final relativeImports = <String>[];
    final packageImports = <String>[];
    for (final match in _importRegex.allMatches(content)) {
      final target = match.group(1)!;
      if (target.startsWith('package:flutter/') || target.startsWith('dart:')) {
        continue;
      }
      if (target.startsWith('package:')) {
        final packageName =
            target.substring('package:'.length).split('/').first;
        if (!packageImports.contains(packageName)) {
          packageImports.add(packageName);
        }
        continue;
      }
      final resolved = p.normalize(p.join(p.dirname(file.path), target));
      final resolvedRel = p
          .relative(resolved, from: storeRoot.path)
          .replaceAll(p.separator, '/');
      if (resolvedRel.startsWith('..')) {
        throw SnippetScanException(
          "$relPath imports '$target', which resolves outside the store's snippet folders.",
        );
      }
      relativeImports.add(resolvedRel);
    }

    final symbols = <String>[];
    for (final match in _declRegex.allMatches(content)) {
      final name = match.group(1)!;
      if (!name.startsWith('_') && !symbols.contains(name)) symbols.add(name);
    }
    for (final match in _typedefRegex.allMatches(content)) {
      final name = match.group(1)!;
      if (!name.startsWith('_') && !symbols.contains(name)) symbols.add(name);
    }
    for (final match in _functionRegex.allMatches(content)) {
      final name = match.group(1)!;
      if (name.startsWith('_') || symbols.contains(name)) continue;
      symbols.add(name);
    }

    return Snippet(
      path: relPath,
      relativeImports: relativeImports,
      packageImports: packageImports,
      symbols: symbols,
      description: _firstDocLine(content),
    );
  }

  String? _firstDocLine(String content) {
    for (final line in content.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('///')) {
        final text = trimmed.substring(3).trim();
        if (text.isNotEmpty) return text;
      }
    }
    return null;
  }
}
