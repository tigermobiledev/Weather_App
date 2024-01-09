import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/utils/extensions.dart';

void main() {
  group('StringExtension', () {
    test('convertToTime', () {
      const String dateTime = '2023-09-24 01:00';
      expect(dateTime.convertToTime(), '01:00');
    });

    test('formatTime', () {
      const String dateTime = '01:00 AM';
      expect(dateTime.formatTime(), '01:00');
    });
  });

  group('DateTimeExtension', () {
    test('convertToDay', () {
      final now = DateTime.now();
      expect(now.convertToDay(), 'today');
    });
  });
}
