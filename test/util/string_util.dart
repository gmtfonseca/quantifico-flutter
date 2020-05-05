import 'package:flutter_test/flutter_test.dart';
import 'package:quantifico/util/string_util.dart';

void main() {
  group('String Util', () {
    const LENGTH_LIMIT = 13;
    group('toLimitedLength', () {
      test('should return same string when limit is greater than length', () async {
        final lengthyWord = 'lengthyWord';
        expect(
          toLimitedLength(lengthyWord, LENGTH_LIMIT),
          lengthyWord,
        );
      });
    });

    test('should return shorter string when length is greater than limit', () async {
      final moreLengthyWord = 'moreLengthyWord';
      expect(
        toLimitedLength(moreLengthyWord, LENGTH_LIMIT),
        'moreLengthyWo',
      );
    });
  });
}
