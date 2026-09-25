import 'dart:io';

import 'package:fcn/src/snippet_scan_exception.dart';
import 'package:fcn/src/snippet_scanner.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory storeRoot;

  setUp(() {
    storeRoot = Directory.systemTemp.createTempSync('fcn_scanner_test_');
  });

  tearDown(() {
    storeRoot.deleteSync(recursive: true);
  });

  void writeFile(String relativePath, String content) {
    final file = File(p.join(storeRoot.path, 'components', relativePath));
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  test('scans a snippet, finding symbols, packages and description', () {
    writeFile('buttons/button.dart', '''
import 'package:flutter/material.dart';

/// Brand primary button.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton();

  @override
  Widget build(BuildContext context) => const SizedBox();
}

enum ButtonSize { sm, md, lg }
''');

    final snippets = SnippetScanner().scan(storeRoot);

    expect(snippets, hasLength(1));
    final snippet = snippets.single;
    expect(snippet.path, 'buttons/button.dart');
    expect(snippet.folder, 'buttons');
    expect(snippet.baseName, 'button');
    expect(snippet.symbols, containsAll(['PrimaryButton', 'ButtonSize']));
    expect(snippet.packageImports, isEmpty);
    expect(snippet.description, 'Brand primary button.');
  });

  test('records relative imports as snippet dependencies', () {
    writeFile('inputs/text_field.dart', '''
import 'package:flutter/material.dart';

/// Labeled text field.
class FormTextField extends StatelessWidget {
  const FormTextField();
  @override
  Widget build(BuildContext context) => const SizedBox();
}
''');
    writeFile('inputs/password_field.dart', '''
import 'package:flutter/material.dart';

import 'text_field.dart';

/// Password field.
class PasswordField extends StatelessWidget {
  const PasswordField();
  @override
  Widget build(BuildContext context) => const FormTextField();
}
''');

    final snippets = SnippetScanner().scan(storeRoot);
    final passwordField = snippets.firstWhere((s) => s.baseName == 'password_field');

    expect(passwordField.relativeImports, ['inputs/text_field.dart']);
  });

  test('records package: imports other than flutter as dependencies', () {
    writeFile('media/svg_icon.dart', '''
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Sized, tintable SVG icon.
class SvgIcon extends StatelessWidget {
  const SvgIcon();
  @override
  Widget build(BuildContext context) => const SizedBox();
}
''');

    final snippet = SnippetScanner().scan(storeRoot).single;

    expect(snippet.packageImports, ['flutter_svg']);
  });

  test('finds a top-level public function symbol', () {
    writeFile('dialogs/confirm_dialog.dart', '''
import 'package:flutter/material.dart';

/// Shows a confirmation dialog.
Future<bool?> showConfirmDialog({required BuildContext context}) async {
  return null;
}
''');

    final snippet = SnippetScanner().scan(storeRoot).single;

    expect(snippet.symbols, ['showConfirmDialog']);
  });

  test('finds generic functions and modified class declarations', () {
    writeFile('dialogs/base_dialog.dart', '''
import 'package:flutter/material.dart';

/// Shows a base dialog.
Future<T?> showBaseDialog<T>({required BuildContext context}) async {
  return null;
}

final class DialogShell {}
''');

    final snippet = SnippetScanner().scan(storeRoot).single;

    expect(snippet.symbols, containsAll(['showBaseDialog', 'DialogShell']));
  });

  test('excludes build, .dart_tool and hidden dirs inside components/', () {
    writeFile('build/generated.dart', 'class Baz {}');
    writeFile('.dart_tool/package_config.dart', 'class Qux {}');
    writeFile('.hidden/file.dart', 'class Hidden {}');
    writeFile('buttons/button.dart', 'class PrimaryButton {}');

    final snippets = SnippetScanner().scan(storeRoot);

    expect(snippets.map((s) => s.path), ['buttons/button.dart']);
  });

  test('does not scan anything outside components/', () {
    final outside = File(p.join(storeRoot.path, 'widgetbook', 'lib', 'store', 'foo.dart'));
    outside.parent.createSync(recursive: true);
    outside.writeAsStringSync('class Foo {}');
    writeFile('buttons/button.dart', 'class PrimaryButton {}');

    final snippets = SnippetScanner().scan(storeRoot);

    expect(snippets.map((s) => s.path), ['buttons/button.dart']);
  });

  test('throws SnippetScanException with a clear message when components/ is missing', () {
    // storeRoot has no components/ directory at all, e.g. a cache from
    // before the components/ restructure.
    expect(
      () => SnippetScanner().scan(storeRoot),
      throwsA(isA<SnippetScanException>().having(
        (e) => e.toString(),
        'message',
        contains('fcn upgrade'),
      )),
    );
  });

  test('throws when a relative import points outside the store', () {
    writeFile('buttons/button.dart', "import '../../outside.dart';\nclass Foo {}");

    expect(() => SnippetScanner().scan(storeRoot), throwsA(isA<SnippetScanException>()));
  });

  test('ignores private (underscore) declarations', () {
    writeFile('buttons/button.dart', '''
class _Button {}
class PrimaryButton {}
''');

    final snippet = SnippetScanner().scan(storeRoot).single;

    expect(snippet.symbols, ['PrimaryButton']);
  });
}
