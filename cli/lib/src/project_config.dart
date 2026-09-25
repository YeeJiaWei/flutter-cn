import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Reads and writes a project's `fcn.json`: the store source, the target
/// directory, and which snippet versions are installed.
class ProjectConfig {
  ProjectConfig({required this.source, required this.dir, required this.installed});

  /// The store: a local path or a git URL, or null to use `~/.fcn/store`.
  String? source;
  String dir;

  /// Snippet path -> the store commit sha it was copied from.
  final Map<String, String> installed;

  static File file(Directory projectRoot) => File(p.join(projectRoot.path, 'fcn.json'));

  /// Loads `fcn.json` from [projectRoot], or null if it doesn't exist.
  static ProjectConfig? tryLoad(Directory projectRoot) {
    final configFile = file(projectRoot);
    if (!configFile.existsSync()) return null;
    final json = jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
    final installedJson = (json['installed'] as Map<String, dynamic>?) ?? {};
    return ProjectConfig(
      source: json['source'] as String?,
      dir: json['dir'] as String,
      installed: installedJson.map((k, v) => MapEntry(k, v as String)),
    );
  }

  /// Writes this config to `fcn.json` in [projectRoot].
  void save(Directory projectRoot) {
    const encoder = JsonEncoder.withIndent('  ');
    file(projectRoot).writeAsStringSync(
      '${encoder.convert({
        'source': source,
        'dir': dir,
        'installed': installed,
      })}\n',
    );
  }
}
