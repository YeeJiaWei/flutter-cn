import 'dart:io';

import 'package:fcn/src/pubspec_reader.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('fcn_pubspec_test_'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('reads top-level dependency names, ignoring nested config and dev_dependencies', () {
    final pubspec = File(p.join(dir.path, 'pubspec.yaml'))
      ..writeAsStringSync('''
name: demo

dependencies:
  flutter:
    sdk: flutter
  flutter_svg: ^2.0.0
  cupertino_icons: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  lints: ^4.0.0
''');

    final names = PubspecReader.dependencyNames(pubspec);

    expect(names, {'flutter', 'flutter_svg', 'cupertino_icons'});
    expect(names, isNot(contains('lints')));
    expect(names, isNot(contains('sdk')));
  });

  test('returns an empty set when the pubspec is missing', () {
    final pubspec = File(p.join(dir.path, 'missing.yaml'));

    expect(PubspecReader.dependencyNames(pubspec), isEmpty);
  });
}
