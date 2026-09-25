import 'dart:io';

import 'package:fcn/src/store_cache.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('a local path source is used as-is, no clone', () {
    final localDir = Directory.systemTemp.createTempSync('fcn_local_store_');
    addTearDown(() => localDir.deleteSync(recursive: true));

    final home = Directory.systemTemp.createTempSync('fcn_home_');
    addTearDown(() => home.deleteSync(recursive: true));

    final resolved = StoreCache(homeDir: home).resolve(localDir.path);

    expect(resolved.path, localDir.path);
    expect(Directory(p.join(home.path, 'stores')).existsSync(), isFalse);
  });

  test('a git URL is cloned, then pulled on the next resolve', () {
    final work = Directory.systemTemp.createTempSync('fcn_git_work_');
    addTearDown(() => work.deleteSync(recursive: true));

    final sourceRepo = Directory(p.join(work.path, 'source'))..createSync();
    Process.runSync('git', ['init', '-q'], workingDirectory: sourceRepo.path);
    Process.runSync('git', ['config', 'user.email', 'test@example.com'], workingDirectory: sourceRepo.path);
    Process.runSync('git', ['config', 'user.name', 'Test'], workingDirectory: sourceRepo.path);
    File(p.join(sourceRepo.path, 'buttons', 'button.dart'))
      ..parent.createSync(recursive: true)
      ..writeAsStringSync('class PrimaryButton {}');
    Process.runSync('git', ['add', '.'], workingDirectory: sourceRepo.path);
    Process.runSync('git', ['commit', '-q', '-m', 'init'], workingDirectory: sourceRepo.path);

    final bareRepo = Directory(p.join(work.path, 'store.git'));
    Process.runSync('git', ['clone', '-q', '--bare', sourceRepo.path, bareRepo.path]);

    final home = Directory(p.join(work.path, 'home'));
    final source = 'file://${bareRepo.path}';

    final resolvedFirst = StoreCache(homeDir: home).resolve(source);
    expect(File(p.join(resolvedFirst.path, 'buttons', 'button.dart')).existsSync(), isTrue);

    // a second resolve should pull, not fail because the clone already exists
    final resolvedSecond = StoreCache(homeDir: home).resolve(source);
    expect(resolvedSecond.path, resolvedFirst.path);
  });
}
