/// Thrown when a snippet file fails to scan, such as a relative import that
/// points outside the store's snippet folders.
class SnippetScanException implements Exception {
  SnippetScanException(this.message);

  final String message;

  @override
  String toString() => message;
}
