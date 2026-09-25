import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Runs `dart run bin/fcn.dart docs …` against a temp store, exercising the
/// command end to end the way CI does.
ProcessResult _runDocs(List<String> args, Directory storeRoot) {
  return Process.runSync(
    'dart',
    ['run', 'bin/fcn.dart', 'docs', ...args, '--source', storeRoot.path],
    workingDirectory: Directory.current.path,
  );
}

void main() {
  late Directory storeRoot;

  setUp(() {
    storeRoot = Directory.systemTemp.createTempSync('fcn_docs_command_');
    void writeSnippet(String path, String content) {
      final file = File(p.join(storeRoot.path, 'components', path))..createSync(recursive: true);
      file.writeAsStringSync(content);
    }

    void writeDoc(String path, String content) {
      final file = File(p.join(storeRoot.path, 'docs', 'components', path))..createSync(recursive: true);
      file.writeAsStringSync(content);
    }

    writeSnippet('buttons/button.dart', '/// A tappable action.\nclass PrimaryButton {}\n');
    writeDoc(
      'buttons/button.md',
      '---\nname: button\nsymbols: [PrimaryButton]\nuse_when: CTAs.\navoid_when: Icon-only actions.\n---\n'
      '# Buttons\nUsage details.\n',
    );
  });

  tearDown(() => storeRoot.deleteSync(recursive: true));

  test('the index groups by folder and shows use_when/avoid_when', () {
    final result = _runDocs([], storeRoot);

    expect(result.exitCode, 0);
    expect(result.stdout, contains('buttons/'));
    expect(result.stdout, contains('button'));
    expect(result.stdout, contains('use: CTAs.'));
    expect(result.stdout, contains('avoid: Icon-only actions.'));
  });

  test('the index --json output parses and includes every component', () {
    final result = _runDocs(['--json'], storeRoot);

    expect(result.exitCode, 0);
    final decoded = jsonDecode(result.stdout as String) as Map<String, dynamic>;
    final components = decoded['components'] as List<dynamic>;
    expect(components, hasLength(1));
    expect(components.first['path'], 'buttons/button.dart');
    expect(components.first['hasDoc'], isTrue);
  });

  test('a component missing its doc shows (no doc) instead of crashing', () {
    final file = File(p.join(storeRoot.path, 'components', 'buttons', 'ghost.dart'))..createSync(recursive: true);
    file.writeAsStringSync('class GhostButton {}\n');

    final result = _runDocs([], storeRoot);

    expect(result.exitCode, 0);
    expect(result.stdout, contains('ghost'));
    expect(result.stdout, contains('(no doc)'));
  });

  test('fcn docs <name> prints the full markdown', () {
    final result = _runDocs(['button'], storeRoot);

    expect(result.exitCode, 0);
    expect(result.stdout, contains('Usage details.'));
  });

  test('fcn docs <symbol> resolves through SnippetLookup', () {
    final result = _runDocs(['PrimaryButton'], storeRoot);

    expect(result.exitCode, 0);
    expect(result.stdout, contains('# Buttons'));
  });

  test('fcn docs <name> --json includes the markdown', () {
    final result = _runDocs(['button', '--json'], storeRoot);

    expect(result.exitCode, 0);
    final decoded = jsonDecode(result.stdout as String) as Map<String, dynamic>;
    expect(decoded['hasDoc'], isTrue);
    expect(decoded['markdown'], contains('Usage details.'));
  });

  test('--check passes and prints a summary when everything is in sync', () {
    final result = _runDocs(['--check'], storeRoot);

    expect(result.exitCode, 0);
    expect(result.stdout, contains('0 problems'));
  });

  test('--check fails with one line per problem when a doc is missing', () {
    final file = File(p.join(storeRoot.path, 'components', 'buttons', 'ghost.dart'))..createSync(recursive: true);
    file.writeAsStringSync('class GhostButton {}\n');

    final result = _runDocs(['--check'], storeRoot);

    expect(result.exitCode, 1);
    expect(result.stdout, contains('missing doc: buttons/ghost.dart'));
  });
}
