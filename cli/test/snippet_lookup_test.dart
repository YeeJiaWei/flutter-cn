import 'package:fcn/src/snippet.dart';
import 'package:fcn/src/snippet_lookup.dart';
import 'package:fcn/src/snippet_lookup_exception.dart';
import 'package:test/test.dart';

Snippet _snippet(String path, {List<String> symbols = const []}) {
  return Snippet(path: path, relativeImports: const [], packageImports: const [], symbols: symbols, description: null);
}

void main() {
  test('resolves by bare file name', () {
    final lookup = SnippetLookup([_snippet('buttons/button.dart')]);

    expect(lookup.resolve('button').path, 'buttons/button.dart');
  });

  test('resolves by folder/name', () {
    final lookup = SnippetLookup([_snippet('dialogs/confirm_dialog.dart')]);

    expect(lookup.resolve('dialogs/confirm_dialog').path, 'dialogs/confirm_dialog.dart');
  });

  test('resolves by public symbol', () {
    final lookup = SnippetLookup([_snippet('buttons/button.dart', symbols: ['PrimaryButton'])]);

    expect(lookup.resolve('PrimaryButton').path, 'buttons/button.dart');
  });

  test('throws with candidates when a bare name is ambiguous', () {
    final lookup = SnippetLookup([
      _snippet('a/thing.dart'),
      _snippet('b/thing.dart'),
    ]);

    expect(
      () => lookup.resolve('thing'),
      throwsA(isA<SnippetLookupException>().having(
        (e) => e.candidates.map((c) => c.path),
        'candidates',
        ['a/thing.dart', 'b/thing.dart'],
      )),
    );
  });

  test('throws not-found for an unknown name', () {
    final lookup = SnippetLookup([_snippet('buttons/button.dart')]);

    expect(() => lookup.resolve('nope'), throwsA(isA<SnippetLookupException>()));
  });
}
