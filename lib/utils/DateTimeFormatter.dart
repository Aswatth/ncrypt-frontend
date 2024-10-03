class DateTimeFormatter {
  static final DateTimeFormatter _instance = DateTimeFormatter._internal();

  DateTimeFormatter._internal();

  factory DateTimeFormatter() {
    return _instance;
  }

  String formatDateTime(DateTime dateTime) {
    final List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    int day = dateTime.day;
    String month = months[dateTime.month - 1];
    int year = dateTime.year;

    bool isAM = true;
    int h = dateTime.hour;
    if (h >= 12) {
      isAM = false;
      h = h - 12;
    }

    String hour = h.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return "$month, $day $year\t$hour:$minute ${isAM ? "AM" : "PM"}";
  }

  String formatTimeMMSS(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}