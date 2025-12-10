String formatTime(final DateTime time) {
  int hour = time.hour;
  final int minute = time.minute;

  final String ampm = hour >= 12 ? "PM" : "AM";

  hour = hour % 12;
  if (hour == 0) hour = 12;

  final String minuteStr = minute.toString().padLeft(2, '0');

  return "$hour:$minuteStr $ampm";
}
