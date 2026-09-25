/// One file in the store: its imports, public symbols and description.
class Snippet {
  const Snippet({
    required this.path,
    required this.relativeImports,
    required this.packageImports,
    required this.symbols,
    required this.description,
  });

  /// Path relative to the store root, e.g. `buttons/button.dart`, forward-slashed.
  final String path;

  /// Other snippet paths this file imports by relative path.
  final List<String> relativeImports;

  /// Pub package names this file imports (excluding flutter/dart).
  final List<String> packageImports;

  /// Public top-level classes, enums, mixins, extensions, typedefs and functions.
  final List<String> symbols;

  /// The first non-empty line of the leading doc comment, if any.
  final String? description;

  /// The top-level folder this snippet lives in, e.g. `buttons`.
  String get folder => path.split('/').first;

  /// The file name, e.g. `button.dart`.
  String get fileName => path.split('/').last;

  /// The file name without its `.dart` extension, e.g. `button`.
  String get baseName => fileName.substring(0, fileName.length - '.dart'.length);
}
