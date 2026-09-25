import 'dart:io';

import 'package:path/path.dart' as p;

import 'component_doc.dart';
import 'doc_front_matter_parser.dart';
import 'snippet.dart';

/// Maps snippets to their usage docs under `docs/components/`, one .md per
/// .dart file, and loads/lists them.
class DocsStore {
  DocsStore(this.storeRoot);

  final Directory storeRoot;

  Directory get docsComponentsDir => Directory(p.join(storeRoot.path, 'docs', 'components'));

  /// The doc file a [snippet] maps to, e.g.
  /// `components/buttons/button.dart` -> `docs/components/buttons/button.md`.
  File docFileFor(Snippet snippet) {
    return File(p.joinAll([docsComponentsDir.path, ...snippet.folder.split('/'), '${snippet.baseName}.md']));
  }

  /// Loads the doc for [snippet], or null if it has none.
  ComponentDoc? load(Snippet snippet) {
    final file = docFileFor(snippet);
    if (!file.existsSync()) return null;
    final markdown = file.readAsStringSync();
    return ComponentDoc(
      snippetPath: snippet.path,
      frontMatter: DocFrontMatterParser.parse(markdown),
      markdown: markdown,
    );
  }

  /// Every doc's snippet path (e.g. `buttons/button.dart`) found under
  /// `docs/components/`, whether or not a matching snippet exists.
  List<String> allDocSnippetPaths() {
    if (!docsComponentsDir.existsSync()) return const [];
    final paths = <String>[];
    for (final entity in docsComponentsDir.listSync(recursive: true, followLinks: false)) {
      if (entity is! File || !entity.path.endsWith('.md')) continue;
      final rel = p.relative(entity.path, from: docsComponentsDir.path).replaceAll(p.separator, '/');
      final withoutExt = rel.substring(0, rel.length - '.md'.length);
      paths.add('$withoutExt.dart');
    }
    paths.sort();
    return paths;
  }
}
