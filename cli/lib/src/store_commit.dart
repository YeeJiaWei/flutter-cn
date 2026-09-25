import 'dart:io';

/// Reads the store's current commit sha, when it's a git repo.
class StoreCommit {
  /// Returns `git rev-parse HEAD` for [storeRoot], or `'local'` when it isn't
  /// a git repo.
  static String read(Directory storeRoot) {
    final result = Process.runSync('git', ['-C', storeRoot.path, 'rev-parse', 'HEAD']);
    if (result.exitCode != 0) return 'local';
    return (result.stdout as String).trim();
  }
}
