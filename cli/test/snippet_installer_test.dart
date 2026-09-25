import 'dart:io';

import 'package:fcn/src/dependency_resolver.dart';
import 'package:fcn/src/project_config.dart';
import 'package:fcn/src/snippet_installer.dart';
import 'package:fcn/src/snippet_scanner.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory storeRoot;
  late Directory projectRoot;

  setUp(() {
    storeRoot = Directory.systemTemp.createTempSync('fcn_install_store_');
    projectRoot = Directory.systemTemp.createTempSync('fcn_install_project_');

    void write(String relativePath, String content) {
      final file = File(p.join(storeRoot.path, 'components', relativePath));
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(content);
    }

    write('inputs/text_field.dart', "class FormTextField {}\n");
    write('inputs/password_field.dart', "import 'text_field.dart';\n\nclass PasswordField {}\n");
  });

  tearDown(() {
    storeRoot.deleteSync(recursive: true);
    projectRoot.deleteSync(recursive: true);
  });

  test('copies a snippet and its dependency, and records them as installed', () {
    final snippets = SnippetScanner().scan(storeRoot);
    final resolved = DependencyResolver(snippets).resolveAll(['inputs/password_field.dart']);
    final config = ProjectConfig(source: storeRoot.path, dir: 'lib/ui/components', installed: {});
    final installer = SnippetInstaller(projectRoot: projectRoot, storeRoot: storeRoot, config: config);

    final result = installer.install(resolved);

    expect(result.copied.map((s) => s.path), ['inputs/text_field.dart', 'inputs/password_field.dart']);
    expect(File(p.join(projectRoot.path, 'lib/ui/components/inputs/text_field.dart')).existsSync(), isTrue);
    expect(File(p.join(projectRoot.path, 'lib/ui/components/inputs/password_field.dart')).existsSync(), isTrue);
    expect(config.installed.keys, containsAll(['inputs/text_field.dart', 'inputs/password_field.dart']));
  });

  test('skips a file that already exists, unless overwrite is passed', () {
    final snippets = SnippetScanner().scan(storeRoot);
    final resolved = DependencyResolver(snippets).resolveAll(['inputs/text_field.dart']);
    final config = ProjectConfig(source: storeRoot.path, dir: 'lib/ui/components', installed: {});
    final installer = SnippetInstaller(projectRoot: projectRoot, storeRoot: storeRoot, config: config);

    installer.install(resolved);
    final second = installer.install(resolved);
    expect(second.skipped.map((s) => s.path), ['inputs/text_field.dart']);
    expect(second.copied, isEmpty);

    final third = installer.install(resolved, overwrite: true);
    expect(third.copied.map((s) => s.path), ['inputs/text_field.dart']);
  });

  test('a dry run writes nothing to disk', () {
    final snippets = SnippetScanner().scan(storeRoot);
    final resolved = DependencyResolver(snippets).resolveAll(['inputs/text_field.dart']);
    final config = ProjectConfig(source: storeRoot.path, dir: 'lib/ui/components', installed: {});
    final installer = SnippetInstaller(projectRoot: projectRoot, storeRoot: storeRoot, config: config);

    final result = installer.install(resolved, dryRun: true);

    expect(result.copied, hasLength(1));
    expect(File(p.join(projectRoot.path, 'lib/ui/components/inputs/text_field.dart')).existsSync(), isFalse);
    expect(config.installed, isEmpty);
  });
}
