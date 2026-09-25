import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'store_cache_exception.dart';

/// Resolves a project's `source` to an on-disk store: null for the store the
/// installer cloned (`~/.fcn/store`), a local path used as-is, or a git URL
/// cloned once and `pull --ff-only`ed after.
class StoreCache {
  StoreCache({required this.homeDir});

  /// The `.fcn` home directory that clones are cached under, e.g. `~/.fcn`.
  final Directory homeDir;

  /// Returns the snippet root for [source], cloning or pulling it first when
  /// it's a git URL. A null [source] resolves to the installer's own store.
  Directory resolve(String? source) {
    if (source == null) return _resolveDefaultStore();

    if (!_isGitUrl(source)) {
      final path = source.startsWith('file://') ? Uri.parse(source).toFilePath() : source;
      return Directory(path);
    }

    final hash = _stableHash(source).toRadixString(16);
    final dest = Directory(p.join(homeDir.path, 'stores', hash));
    if (dest.existsSync()) {
      _run(['git', '-C', dest.path, 'pull', '--ff-only']);
    } else {
      dest.parent.createSync(recursive: true);
      _run(['git', 'clone', '--depth', '1', source, dest.path]);
    }
    return dest;
  }

  Directory _resolveDefaultStore() {
    final dest = Directory(p.join(homeDir.path, 'store'));
    if (!dest.existsSync()) {
      throw StoreCacheException(
        'No store found at ${dest.path}. fcn isn\'t installed properly — re-run the installer:\n'
        '  curl -fsSL https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.sh | bash',
      );
    }
    // Best-effort refresh; fall back silently to the cached copy when offline.
    try {
      _run(['git', '-C', dest.path, 'pull', '--ff-only']);
    } on StoreCacheException {
      // offline or non-fast-forward — keep using the cached copy
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

  /// FNV-1a over the UTF-8 bytes of [value]: a hash stable across Dart runs,
  /// unlike [String.hashCode] which isn't guaranteed stable.
  int _stableHash(String value) {
    const fnvPrime = 0x01000193;
    const fnvOffsetBasis = 0x811c9dc5;
    var hash = fnvOffsetBasis;
    for (final byte in utf8.encode(value)) {
      hash ^= byte;
      hash = (hash * fnvPrime) & 0xffffffff;
    }
    return hash;
  }

  void _run(List<String> args) {
    final result = Process.runSync(args.first, args.sublist(1));
    if (result.exitCode != 0) {
      throw StoreCacheException('${args.join(' ')} failed: ${result.stderr}');
    }
  }
}
