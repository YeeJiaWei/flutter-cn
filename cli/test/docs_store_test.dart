import 'dart:io';

import 'package:fcn/src/docs_store.dart';
import 'package:fcn/src/snippet.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

Snippet _snippet(String path, {List<String> symbols = const []}) {
  return Snippet(path: path, relativeImports: const [], packageImports: const [], symbols: symbols, description: null);
}

void main() {
  late Directory storeRoot;

  setUp(() => storeRoot = Directory.systemTemp.createTempSync('fcn_docs_store_'));
  tearDown(() => storeRoot.deleteSync(recursive: true));

  test('maps a snippet to its doc file under docs/components/', () {
    final docsStore = DocsStore(storeRoot);
    final file = docsStore.docFileFor(_snippet('buttons/button.dart'));

    expect(file.path, p.join(storeRoot.path, 'docs', 'components', 'buttons', 'button.md'));
  });

  test('loads a doc when its file exists', () {
    final docFile = File(p.join(storeRoot.path, 'docs', 'components', 'buttons', 'button.md'))
      ..createSync(recursive: true);
    docFile.writeAsStringSync('---\nname: button\nuse_when: CTAs.\navoid_when: Icons.\n---\n# Buttons\n');

    final doc = DocsStore(storeRoot).load(_snippet('buttons/button.dart'));

    expect(doc, isNotNull);
    expect(doc!.snippetPath, 'buttons/button.dart');
    expect(doc.frontMatter.name, 'button');
    expect(doc.markdown, contains('# Buttons'));
  });

  test('returns null when there is no doc for a snippet', () {
    final doc = DocsStore(storeRoot).load(_snippet('buttons/button.dart'));

    expect(doc, isNull);
  });

  test('lists every doc found under docs/components/, as snippet-shaped paths', () {
    void write(String relativeMdPath) {
      final file = File(p.join(storeRoot.path, 'docs', 'components', relativeMdPath))..createSync(recursive: true);
      file.writeAsStringSync('---\n---\n');
    }

    write('buttons/button.md');
    write('dialogs/confirm_dialog.md');

    final paths = DocsStore(storeRoot).allDocSnippetPaths();

    expect(paths, ['buttons/button.dart', 'dialogs/confirm_dialog.dart']);
  });

  test('lists no docs when docs/components/ does not exist', () {
    expect(DocsStore(storeRoot).allDocSnippetPaths(), isEmpty);
  });
}
