import 'doc_front_matter.dart';

/// Parses the leading `---` front-matter block of a component doc with a
/// small line-based reader — the keys are known, so there's no yaml
/// dependency.
class DocFrontMatterParser {
  /// Parses [content]'s front matter. Missing keys come back null/empty;
  /// content with no `---` block at all also comes back empty.
  static DocFrontMatter parse(String content) {
    final lines = content.split('\n');
    if (lines.isEmpty || lines.first.trim() != '---') return const DocFrontMatter();

    var end = -1;
    for (var i = 1; i < lines.length; i++) {
      if (lines[i].trim() == '---') {
        end = i;
        break;
      }
    }
    if (end == -1) return const DocFrontMatter();

    String? name;
    List<String> symbols = const [];
    String? useWhen;
    String? avoidWhen;
    List<String> related = const [];

    for (final line in lines.sublist(1, end)) {
      final colon = line.indexOf(':');
      if (colon == -1) continue;
      final key = line.substring(0, colon).trim();
      final rawValue = line.substring(colon + 1).trim();
      switch (key) {
        case 'name':
          name = rawValue.isEmpty ? null : rawValue;
        case 'symbols':
          symbols = _parseList(rawValue);
        case 'use_when':
          useWhen = rawValue.isEmpty ? null : rawValue;
        case 'avoid_when':
          avoidWhen = rawValue.isEmpty ? null : rawValue;
        case 'related':
          related = _parseList(rawValue);
      }
    }

    return DocFrontMatter(
      name: name,
      symbols: symbols,
      useWhen: useWhen,
      avoidWhen: avoidWhen,
      related: related,
    );
  }

  static List<String> _parseList(String rawValue) {
    var value = rawValue.trim();
    if (value.startsWith('[') && value.endsWith(']')) {
      value = value.substring(1, value.length - 1);
    }
    if (value.isEmpty) return const [];
    return value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }
}
