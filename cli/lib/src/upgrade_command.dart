import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

/// The store's public repo, mirrored from `install.sh`'s `DEFAULT_REPO`.
const String defaultRepo = 'https://github.com/YeeJiaWei/flutter-cn';

/// Where the hosted installer scripts live, mirrored on `main`.
const String rawInstallerBase = 'https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main';

/// `fcn upgrade` — re-runs the hosted installer for this OS, which pulls the
/// latest release binary (or store, when building from source) and the store.
class UpgradeCommand extends Command<int> {
  @override
  final name = 'upgrade';

  @override
  final description = 'Re-run the installer to update fcn and the store.';

  @override
  Future<int> run() async {
    final home = Platform.environment['HOME'] ?? '';
    final storeDir = Directory(p.join(home, '.fcn', 'store'));

    final environment = <String, String>{};
    if (storeDir.existsSync()) {
      final originResult = Process.runSync('git', ['-C', storeDir.path, 'remote', 'get-url', 'origin']);
      final origin = originResult.exitCode == 0 ? (originResult.stdout as String).trim() : '';
      if (origin.isNotEmpty && !origin.contains('YeeJiaWei/flutter-cn')) {
        environment['FCN_REPO'] = origin;
      }
    }

    final String executable;
    final List<String> args;
    if (Platform.isWindows) {
      executable = 'powershell';
      args = ['-NoProfile', '-Command', 'irm $rawInstallerBase/install.ps1 | iex'];
    } else {
      executable = 'bash';
      args = ['-c', 'curl -fsSL $rawInstallerBase/install.sh | bash'];
    }

    final process = await Process.start(
      executable,
      args,
      environment: environment,
      includeParentEnvironment: true,
      mode: ProcessStartMode.inheritStdio,
    );
    return process.exitCode;
  }
}
