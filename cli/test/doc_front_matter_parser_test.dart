import 'package:fcn/src/doc_front_matter_parser.dart';
import 'package:test/test.dart';

void main() {
  test('parses all known keys', () {
    const content = '''
---
name: button
symbols: [ButtonSize, PrimaryButton, SecondaryButton]
use_when: Any tappable action.
avoid_when: Icon-only toolbar actions.
related: [dialogs/confirm_dialog, cards/surface_card]
---
# Buttons
Body text.
''';

    final fm = DocFrontMatterParser.parse(content);

    expect(fm.name, 'button');
    expect(fm.symbols, ['ButtonSize', 'PrimaryButton', 'SecondaryButton']);
    expect(fm.useWhen, 'Any tappable action.');
    expect(fm.avoidWhen, 'Icon-only toolbar actions.');
    expect(fm.related, ['dialogs/confirm_dialog', 'cards/surface_card']);
  });

  test('missing keys come back null/empty', () {
    const content = '''
---
name: button
---
Body.
''';

    final fm = DocFrontMatterParser.parse(content);

    expect(fm.name, 'button');
    expect(fm.symbols, isEmpty);
    expect(fm.useWhen, isNull);
    expect(fm.avoidWhen, isNull);
    expect(fm.related, isEmpty);
  });

  test('content with no front matter block comes back empty', () {
    final fm = DocFrontMatterParser.parse('# Just a heading\nNo front matter here.');

    expect(fm.name, isNull);
    expect(fm.symbols, isEmpty);
    expect(fm.useWhen, isNull);
    expect(fm.avoidWhen, isNull);
    expect(fm.related, isEmpty);
  });

  test('an unclosed front matter block comes back empty', () {
    final fm = DocFrontMatterParser.parse('---\nname: button\nno closing marker');

    expect(fm.name, isNull);
  });

  test('an empty list value parses to empty', () {
    const content = '''
---
name: button
symbols: []
---
Body.
''';

    final fm = DocFrontMatterParser.parse(content);

    expect(fm.symbols, isEmpty);
  });
}
