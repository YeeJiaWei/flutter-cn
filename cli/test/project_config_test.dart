import 'dart:io';

import 'package:fcn/src/project_config.dart';
import 'package:test/test.dart';

void main() {
  late Directory projectRoot;

  setUp(() => projectRoot = Directory.systemTemp.createTempSync('fcn_config_test_'));
  tearDown(() => projectRoot.deleteSync(recursive: true));

  test('round-trips through fcn.json', () {
    final config = ProjectConfig(
      source: '/path/to/store',
      dir: 'lib/ui/snippets',
      installed: {'buttons/button.dart': 'abc123'},
    );

    config.save(projectRoot);
    final loaded = ProjectConfig.tryLoad(projectRoot)!;

    expect(loaded.source, '/path/to/store');
    expect(loaded.dir, 'lib/ui/snippets');
    expect(loaded.installed, {'buttons/button.dart': 'abc123'});
  });

  test('tryLoad returns null when fcn.json is missing', () {
    expect(ProjectConfig.tryLoad(projectRoot), isNull);
  });
}
