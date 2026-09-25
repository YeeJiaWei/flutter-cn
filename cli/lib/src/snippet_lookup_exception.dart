import 'snippet.dart';

/// Thrown when a name given to `fcn add`/`fcn diff` doesn't resolve to
/// exactly one snippet.
class SnippetLookupException implements Exception {
  SnippetLookupException.notFound(this.query)
      : candidates = const [],
        message = 'No snippet matches "$query".';

  SnippetLookupException.ambiguous(this.query, this.candidates)
      : message = '"$query" matches more than one snippet: '
            '${candidates.map((c) => c.path).join(', ')}. '
            'Use folder/name to disambiguate, e.g. "${candidates.first.folder}/${candidates.first.baseName}".';

  final String query;
  final List<Snippet> candidates;
  final String message;

  @override
  String toString() => message;
}
