import 'dart:io';

import 'package:path/path.dart' as p;

import 'store_cache_exception.dart';

/// Resolves a project's `source` to an on-disk store: a local path used
/// as-is, or a git URL cloned once and `pull --ff-only`ed after.
class StoreCache {
  StoreCache({required this.homeDir});

  /// The `.fcn` home directory that clones are cached under, e.g. `~/.fcn`.
  final Directory homeDir;

  /// Returns the snippet root for [source], cloning or pulling it first when
  /// it's a git URL.
  Directory resolve(String source) {
    if (!_isGitUrl(source)) {
      final path = source.startsWith('file://') ? Uri.parse(source).toFilePath() : source;
      return Directory(path);
    }

    final hash = source.hashCode.abs().toRadixString(16);
    final dest = Directory(p.join(homeDir.path, 'stores', hash));
    if (dest.existsSync()) {
      _run(['git', '-C', dest.path, 'pull', '--ff-only']);
    } else {
      dest.parent.createSync(recursive: true);
      _run(['git', 'clone', '--depth', '1', source, dest.path]);
    }
    return dest;
  }

  bool _isGitUrl(String source) {
    if (source.startsWith('http://') ||
        source.startsWith('https://') ||
        source.startsWith('git@') ||
        source.startsWith('ssh://')) {
      return true;
    }
    return source.endsWith('.git');
  }

  void _run(List<String> args) {
    final result = Process.runSync(args.first, args.sublist(1));
    if (result.exitCode != 0) {
      throw StoreCacheException('${args.join(' ')} failed: ${result.stderr}');
    }
  }
}
