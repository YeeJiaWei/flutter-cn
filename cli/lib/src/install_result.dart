import 'snippet.dart';

/// The outcome of copying a set of snippets into a project.
class InstallResult {
  const InstallResult({required this.copied, required this.skipped});

  /// Snippets copied (or that would be copied, in a dry run).
  final List<Snippet> copied;

  /// Snippets left alone because the target file already exists.
  final List<Snippet> skipped;
}
