import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fcn/src/init_command.dart';
import 'package:fcn/src/project_config.dart';
import 'package:test/test.dart';

void main() {
  late Directory projectRoot;
  late Directory originalCwd;

  setUp(() {
    originalCwd = Directory.current;
    projectRoot = Directory.systemTemp.createTempSync('fcn_init_test_');
    Directory.current = projectRoot;
  });

  tearDown(() {
    Directory.current = originalCwd;
    projectRoot.deleteSync(recursive: true);
  });

  test('init without --source writes a null source, defaulting to ~/.fcn/store', () async {
    final runner = CommandRunner<int>('fcn', 'test')..addCommand(InitCommand());
    // stdin has no terminal under `dart test`, so --dir with no flag defaults
    // rather than blocking on a prompt.
    final code = await runner.run(['init']);

    expect(code, 0);
    final config = ProjectConfig.tryLoad(projectRoot)!;
    expect(config.source, isNull);
    expect(config.dir, 'lib/ui');
  });

  test('init with --source and --dir writes both', () async {
    final runner = CommandRunner<int>('fcn', 'test')..addCommand(InitCommand());
    final code = await runner.run(['init', '--source', '/path/to/store', '--dir', 'lib/ui/snippets']);

    expect(code, 0);
    final config = ProjectConfig.tryLoad(projectRoot)!;
    expect(config.source, '/path/to/store');
    expect(config.dir, 'lib/ui/snippets');
  });
}
