import 'dart:io';

import 'package:fcn/src/docs_checker.dart';
import 'package:fcn/src/docs_store.dart';
import 'package:fcn/src/snippet.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

Snippet _snippet(String path, {List<String> symbols = const []}) {
  return Snippet(path: path, relativeImports: const [], packageImports: const [], symbols: symbols, description: null);
}

void main() {
  late Directory storeRoot;

  setUp(() => storeRoot = Directory.systemTemp.createTempSync('fcn_docs_checker_'));
  tearDown(() => storeRoot.deleteSync(recursive: true));

  void writeDoc(String relativeMdPath, String content) {
    final file = File(p.join(storeRoot.path, 'docs', 'components', relativeMdPath))..createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  test('reports a missing doc for a component with no .md', () {
    final snippets = [_snippet('buttons/button.dart', symbols: ['PrimaryButton'])];

    final problems = DocsChecker().check(snippets, DocsStore(storeRoot));

    expect(problems, [contains('missing doc: buttons/button.dart')]);
  });

  test('reports an orphan doc with no matching component', () {
    writeDoc('buttons/ghost.md', '---\nname: ghost\nuse_when: x\navoid_when: y\n---\n');

    final problems = DocsChecker().check(const [], DocsStore(storeRoot));

    expect(problems, [contains('orphan doc: docs/components/buttons/ghost.md')]);
  });

  test('reports missing use_when and avoid_when', () {
    final snippets = [_snippet('buttons/button.dart')];
    writeDoc('buttons/button.md', '---\nname: button\n---\n# Buttons\n');

    final problems = DocsChecker().check(snippets, DocsStore(storeRoot));

    expect(problems, containsAll([contains('missing use_when'), contains('missing avoid_when')]));
  });

  test('reports a symbols mismatch against the scanner', () {
    final snippets = [
      _snippet('buttons/button.dart', symbols: ['PrimaryButton', 'SecondaryButton']),
    ];
    writeDoc(
      'buttons/button.md',
      '---\nname: button\nsymbols: [PrimaryButton]\nuse_when: x\navoid_when: y\n---\n',
    );

    final problems = DocsChecker().check(snippets, DocsStore(storeRoot));

    expect(problems, [contains('symbols mismatch')]);
  });

  test('symbols mismatch check is order-insensitive', () {
    final snippets = [
      _snippet('buttons/button.dart', symbols: ['PrimaryButton', 'SecondaryButton']),
    ];
    writeDoc(
      'buttons/button.md',
      '---\nname: button\nsymbols: [SecondaryButton, PrimaryButton]\nuse_when: x\navoid_when: y\n---\n',
    );

    final problems = DocsChecker().check(snippets, DocsStore(storeRoot));

    expect(problems, isEmpty);
  });

  test('reports an unresolvable related entry', () {
    final snippets = [_snippet('buttons/button.dart')];
    writeDoc(
      'buttons/button.md',
      '---\nname: button\nuse_when: x\navoid_when: y\nrelated: [dialogs/nonexistent]\n---\n',
    );

    final problems = DocsChecker().check(snippets, DocsStore(storeRoot));

    expect(problems, [contains('unresolvable related')]);
  });

  test('a resolvable related entry passes', () {
    final snippets = [
      _snippet('buttons/button.dart'),
      _snippet('dialogs/confirm_dialog.dart'),
    ];
    writeDoc(
      'buttons/button.md',
      '---\nname: button\nuse_when: x\navoid_when: y\nrelated: [dialogs/confirm_dialog]\n---\n',
    );
    writeDoc('dialogs/confirm_dialog.md', '---\nname: confirm_dialog\nuse_when: x\navoid_when: y\n---\n');

    final problems = DocsChecker().check(snippets, DocsStore(storeRoot));

    expect(problems, isEmpty);
  });

  test('reports nothing when every component has a complete, accurate doc', () {
    final snippets = [_snippet('buttons/button.dart', symbols: ['PrimaryButton'])];
    writeDoc(
      'buttons/button.md',
      '---\nname: button\nsymbols: [PrimaryButton]\nuse_when: x\navoid_when: y\n---\n# Buttons\n',
    );

    final problems = DocsChecker().check(snippets, DocsStore(storeRoot));

    expect(problems, isEmpty);
  });
}
