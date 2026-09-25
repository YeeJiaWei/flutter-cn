import 'dart:io';

/// Reads a project's `pubspec.yaml` dependency names with a light line-based
/// parse, no `yaml` dependency needed.
class PubspecReader {
  static final _keyRegex = RegExp(r'^\s*([A-Za-z0-9_]+):');

  /// Returns the package names listed under `dependencies:` in [pubspecFile].
  static Set<String> dependencyNames(File pubspecFile) {
    final names = <String>{};
    if (!pubspecFile.existsSync()) return names;
    var inDependencies = false;
    for (final rawLine in pubspecFile.readAsLinesSync()) {
      if (rawLine.trim().isEmpty || rawLine.trimLeft().startsWith('#')) continue;
      final indent = rawLine.length - rawLine.trimLeft().length;
      if (indent == 0) {
        inDependencies = rawLine.trimRight() == 'dependencies:';
        continue;
      }
      if (!inDependencies || indent != 2) continue;
      final match = _keyRegex.firstMatch(rawLine);
      if (match != null) names.add(match.group(1)!);
    }
    return names;
  }
}
