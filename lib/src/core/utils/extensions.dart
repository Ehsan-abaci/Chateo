import 'package:intl/intl.dart';

extension MessageTime on DateTime {
  String get toUserCardTime {
    final now = DateTime.now();

    // Check if the date is today
    if (now.year == year && now.month == month && now.day == day) {
      return DateFormat('HH:mm').format(this); // Format as HH:MM if it's today
    } else {
      return DateFormat('MMM dd').format(this); // Format as "MMM dd" otherwise
    }
  }

  String get toBubbleChatTime => DateFormat('HH:mm').format(this);
}

extension Sort on List<dynamic> {
  List<dynamic> sortByTime() {
    sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return this;
  }
}

extension LastMsg on String {
  String toLastMsgFormat() => split('\n')
      .fold('', (previousValue, element) => '$previousValue $element');
}

extension ToHMS on Duration {
  String toHms() {
    var hour = inHours;
    var minute = inMinutes - hour * 60;
    var second = inSeconds - minute * 60;

    return "${hour == 0 ? '' : "$hour:"}${minute < 10 ? "0$minute" : minute}:${second < 10 ? "0$second" : second}";
  }
}
