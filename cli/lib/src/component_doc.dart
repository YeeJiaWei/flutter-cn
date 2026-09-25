import 'doc_front_matter.dart';

/// A component's usage doc: its front matter plus the full markdown, as
/// loaded from `docs/components/<folder>/<file>.md`.
class ComponentDoc {
  const ComponentDoc({
    required this.snippetPath,
    required this.frontMatter,
    required this.markdown,
  });

  /// The snippet path this doc is for, e.g. `buttons/button.dart`.
  final String snippetPath;

  final DocFrontMatter frontMatter;

  /// The full file content, front matter included.
  final String markdown;
}
