/// Thrown when cloning or pulling the store cache fails.
class StoreCacheException implements Exception {
  StoreCacheException(this.message);

  final String message;

  @override
  String toString() => message;
}
