import 'dart:io';

import 'package:path/path.dart' as p;

import 'snippet_scan_exception.dart';

/// Resolves the store's `components/` directory, where every snippet lives.
///
/// Throws [SnippetScanException] when [storeRoot] has no `components/`
/// directory, e.g. a `~/.fcn/store` cache from before the components/
/// restructure.
Directory componentsDir(Directory storeRoot) {
  final dir = Directory(p.join(storeRoot.path, 'components'));
  if (!dir.existsSync()) {
    throw SnippetScanException(
      'No components/ directory found in the store at ${storeRoot.path}. '
      'If this is a cached store from before the components/ restructure, run `fcn upgrade`.',
    );
  }
  return dir;
}
