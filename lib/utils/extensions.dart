import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../config/translations/strings_enum.dart';

extension StringExtension on String {
  /// get the existing countries only
  String toRightCountry() {
    if (this == 'Israel') return 'Palestine';
    return this;
  }

  /// get the existing cities only
  String toRightCity() {
    if (this == 'Sederot') return 'Gaza';
    return this;
  }

  /// convert the date to time => 2023-09-24 01:00 = 01:00
  String convertToTime() {
    var dateTime = DateTime.parse(this);
    if (dateTime.hour == DateTime.now().hour) return Strings.now.tr;
    return DateFormat('HH:mm').format(dateTime);
  }

  /// format the time => 01:00 AM = 01:00
  String formatTime() {
    var dateTime = DateFormat("hh:mm a").parse(this);
    return DateFormat("hh:mm").format(dateTime);
  }
}

extension DateTimeExtension on DateTime {
  /// convert the DateTime to day => 2023-09-24 = Sunday
  String convertToDay() {
    if (day == DateTime.now().day) return Strings.today.tr;
    return DateFormat.EEEE().format(this);
  }
}
