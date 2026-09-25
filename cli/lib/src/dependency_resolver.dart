import 'snippet.dart';

/// Follows a snippet's relative imports to find every other snippet it needs.
class DependencyResolver {
  DependencyResolver(this.snippets);

  final List<Snippet> snippets;

  /// Returns [rootPaths] and everything they transitively import, dependencies
  /// first, each snippet appearing once.
  List<Snippet> resolveAll(Iterable<String> rootPaths) {
    final byPath = {for (final s in snippets) s.path: s};
    final visited = <String>{};
    final result = <Snippet>[];

    void visit(String path) {
      if (visited.contains(path)) return;
      visited.add(path);
      final snippet = byPath[path];
      if (snippet == null) return;
      for (final dep in snippet.relativeImports) {
        visit(dep);
      }
      result.add(snippet);
    }

    for (final path in rootPaths) {
      visit(path);
    }
    return result;
  }
}
