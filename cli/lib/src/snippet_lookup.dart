import 'snippet.dart';
import 'snippet_lookup_exception.dart';

/// Resolves a name typed on the command line to exactly one [Snippet]: a
/// `folder/name` path, a bare file name, or a public symbol it exports.
class SnippetLookup {
  SnippetLookup(this.snippets);

  final List<Snippet> snippets;

  /// Resolves [query] to one snippet, or throws [SnippetLookupException] when
  /// it matches none or more than one.
  Snippet resolve(String query) {
    final normalized = query.endsWith('.dart') ? query.substring(0, query.length - 5) : query;

    if (normalized.contains('/')) {
      final match = snippets.where((s) => '${s.folder}/${s.baseName}' == normalized);
      if (match.isEmpty) throw SnippetLookupException.notFound(query);
      return match.first;
    }

    final byName = snippets.where((s) => s.baseName == normalized).toList();
    if (byName.length == 1) return byName.first;
    if (byName.length > 1) throw SnippetLookupException.ambiguous(query, byName);

    final bySymbol = snippets.where((s) => s.symbols.contains(query)).toList();
    if (bySymbol.length == 1) return bySymbol.first;
    if (bySymbol.length > 1) throw SnippetLookupException.ambiguous(query, bySymbol);

    throw SnippetLookupException.notFound(query);
  }
}
