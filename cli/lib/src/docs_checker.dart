import 'docs_store.dart';
import 'snippet.dart';

/// Validates that every snippet has a doc, every doc has a snippet, and each
/// doc's front matter is complete and accurate.
class DocsChecker {
  /// Returns one problem description per line; empty when [snippets] and
  /// [docsStore] are fully in sync.
  List<String> check(List<Snippet> snippets, DocsStore docsStore) {
    final problems = <String>[];
    final knownPaths = {for (final s in snippets) '${s.folder}/${s.baseName}'};

    for (final snippet in snippets) {
      final doc = docsStore.load(snippet);
      if (doc == null) {
        problems.add('missing doc: ${snippet.path} has no docs/components/${snippet.folder}/${snippet.baseName}.md');
        continue;
      }

      final fm = doc.frontMatter;
      if (fm.useWhen == null || fm.useWhen!.isEmpty) {
        problems.add('missing use_when: docs/components/${snippet.folder}/${snippet.baseName}.md');
      }
      if (fm.avoidWhen == null || fm.avoidWhen!.isEmpty) {
        problems.add('missing avoid_when: docs/components/${snippet.folder}/${snippet.baseName}.md');
      }

      final docSymbols = fm.symbols.toSet();
      final actualSymbols = snippet.symbols.toSet();
      if (docSymbols.difference(actualSymbols).isNotEmpty || actualSymbols.difference(docSymbols).isNotEmpty) {
        problems.add(
          'symbols mismatch: docs/components/${snippet.folder}/${snippet.baseName}.md '
          'has [${fm.symbols.join(', ')}], ${snippet.path} has [${snippet.symbols.join(', ')}]',
        );
      }

      for (final related in fm.related) {
        if (!knownPaths.contains(related)) {
          problems.add(
            'unresolvable related: docs/components/${snippet.folder}/${snippet.baseName}.md '
            'references "$related", which matches no component',
          );
        }
      }
    }

    final snippetPaths = {for (final s in snippets) s.path};
    for (final docPath in docsStore.allDocSnippetPaths()) {
      if (!snippetPaths.contains(docPath)) {
        problems.add('orphan doc: docs/components/${docPath.substring(0, docPath.length - '.dart'.length)}.md '
            'has no matching component at components/$docPath');
      }
    }

    return problems;
  }
}
