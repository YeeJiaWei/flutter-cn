/// The parsed `---` front matter block of a component doc.
class DocFrontMatter {
  const DocFrontMatter({
    this.name,
    this.symbols = const [],
    this.useWhen,
    this.avoidWhen,
    this.related = const [],
  });

  /// The `name:` value, e.g. `button`.
  final String? name;

  /// The `symbols: [a, b]` list.
  final List<String> symbols;

  /// The `use_when:` value.
  final String? useWhen;

  /// The `avoid_when:` value.
  final String? avoidWhen;

  /// The `related: [folder/name]` list.
  final List<String> related;
}
