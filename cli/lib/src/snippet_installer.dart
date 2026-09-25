import 'dart:io';

import 'package:path/path.dart' as p;

import 'install_result.dart';
import 'project_config.dart';
import 'snippet.dart';
import 'store_commit.dart';
import 'store_layout.dart';

/// Copies resolved snippets from the store cache into a project's snippet
/// directory, unchanged, and records what was installed.
class SnippetInstaller {
  SnippetInstaller({required this.projectRoot, required this.storeRoot, required this.config});

  final Directory projectRoot;
  final Directory storeRoot;
  final ProjectConfig config;

  /// Copies [snippets], skipping ones already present unless [overwrite].
  /// Writes nothing to disk when [dryRun].
  InstallResult install(List<Snippet> snippets, {bool overwrite = false, bool dryRun = false}) {
    final copied = <Snippet>[];
    final skipped = <Snippet>[];
    final commit = StoreCommit.read(storeRoot);
    final source = componentsDir(storeRoot);

    for (final snippet in snippets) {
      final target = File(p.joinAll([projectRoot.path, config.dir, ...snippet.path.split('/')]));
      if (target.existsSync() && !overwrite) {
        skipped.add(snippet);
        continue;
      }
      if (!dryRun) {
        target.parent.createSync(recursive: true);
        File(p.joinAll([source.path, ...snippet.path.split('/')])).copySync(target.path);
        config.installed[snippet.path] = commit;
      }
      copied.add(snippet);
    }

    return InstallResult(copied: copied, skipped: skipped);
  }
}
