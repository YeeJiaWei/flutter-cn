import 'package:fcn/src/dependency_resolver.dart';
import 'package:fcn/src/snippet.dart';
import 'package:test/test.dart';

Snippet _snippet(String path, {List<String> imports = const []}) {
  return Snippet(path: path, relativeImports: imports, packageImports: const [], symbols: const [], description: null);
}

void main() {
  test('resolves transitive relative-import dependencies, dependencies first', () {
    final textField = _snippet('inputs/text_field.dart');
    final passwordField = _snippet('inputs/password_field.dart', imports: ['inputs/text_field.dart']);
    final resolver = DependencyResolver([textField, passwordField]);

    final result = resolver.resolveAll(['inputs/password_field.dart']);

    expect(result.map((s) => s.path), ['inputs/text_field.dart', 'inputs/password_field.dart']);
  });

  test('deduplicates a snippet shared by two roots', () {
    final base = _snippet('dialogs/base_dialog.dart');
    final a = _snippet('dialogs/a.dart', imports: ['dialogs/base_dialog.dart']);
    final b = _snippet('dialogs/b.dart', imports: ['dialogs/base_dialog.dart']);
    final resolver = DependencyResolver([base, a, b]);

    final result = resolver.resolveAll(['dialogs/a.dart', 'dialogs/b.dart']);

    expect(result.map((s) => s.path), ['dialogs/base_dialog.dart', 'dialogs/a.dart', 'dialogs/b.dart']);
  });

  test('does not loop on a cyclical import', () {
    final a = _snippet('a.dart', imports: ['b.dart']);
    final b = _snippet('b.dart', imports: ['a.dart']);
    final resolver = DependencyResolver([a, b]);

    final result = resolver.resolveAll(['a.dart']);

    expect(result.map((s) => s.path).toSet(), {'a.dart', 'b.dart'});
  });
}
