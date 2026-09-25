import 'package:fcn/src/fcn_version.dart';
import 'package:test/test.dart';

void main() {
  test('defaults to dev when built without -DFCN_VERSION', () {
    expect(fcnVersion, 'dev');
  });
}
