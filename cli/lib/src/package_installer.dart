import 'dart:io';

import 'package:path/path.dart' as p;

import 'pubspec_reader.dart';

/// Adds pub packages a snippet needs to the project, skipping ones already
/// listed in its `pubspec.yaml`.
class PackageInstaller {
  /// Runs `flutter pub add` for whichever of [packages] the project doesn't
  /// already depend on.
  static void addMissing(Directory projectRoot, Set<String> packages) {
    final pubspec = File(p.join(projectRoot.path, 'pubspec.yaml'));
    final missing = packages.difference(PubspecReader.dependencyNames(pubspec));
    if (missing.isEmpty) return;

    stdout.writeln('Adding packages: ${missing.join(', ')}');
    final result = Process.runSync(
      'flutter',
      ['pub', 'add', ...missing],
      workingDirectory: projectRoot.path,
    );
    if (result.exitCode != 0) {
      stderr.writeln('flutter pub add ${missing.join(' ')} failed:\n${result.stderr}');
    }
  }
}
