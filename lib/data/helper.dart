import 'package:intl/intl.dart';

String formatSmartDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  final isToday = now.day == date.day && now.month == date.month && now.year == date.year;

  if (difference.inHours < 24 && isToday) {
    // Less than 1 day ago, same date
    return DateFormat.Hm().format(date); // e.g., 07:43
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7 && date.isAfter(now.subtract(Duration(days: now.weekday)))) {
    return DateFormat.EEEE().format(date); // e.g., Monday
  } else if (date.year == now.year) {
    return DateFormat('dd.MM').format(date); // e.g., 11.02
  } else {
    return DateFormat('dd.MM.yy').format(date); // e.g., 11.02.21
  }
}
