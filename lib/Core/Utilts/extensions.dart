import 'package:intl/intl.dart';

extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Capitalizes the first letter of each word in the string
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Removes all whitespace from the string
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Returns true if the string is a valid email address
  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Returns true if the string is a valid URL
  bool isValidUrl() {
    return RegExp(r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$').hasMatch(this);
  }

  /// Returns true if the string is a valid phone number
  bool isValidPhone() {
    return RegExp(r'^\+?[\d\s\-\(\)]{8,}$').hasMatch(this);
  }

  /// Truncates the string to the specified length and adds ellipsis if needed
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Checks if string is numeric
  bool isNumeric() {
    return double.tryParse(this) != null;
  }
}

extension DateTimeExtensions on DateTime {
  /// Formats the DateTime to a string with the specified format
  String toFormattedString({String format = 'dd/MM/yyyy'}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(this);
  }

  /// Returns a DateTime with the time set to the start of the day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns a DateTime with the time set to the end of the day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Returns a DateTime with the time set to the start of the month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Returns a DateTime with the time set to the end of the month
  DateTime get endOfMonth {
    final nextMonth = month < 12 ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).endOfDay;
  }

  /// Returns a DateTime with the time set to the start of the week (Monday)
  DateTime get startOfWeek {
    final daysToSubtract = weekday - 1;
    return subtract(Duration(days: daysToSubtract)).startOfDay;
  }

  /// Returns a DateTime with the time set to the end of the week (Sunday)
  DateTime get endOfWeek {
    final daysToAdd = 7 - weekday;
    return add(Duration(days: daysToAdd)).endOfDay;
  }

  /// Returns a DateTime with the time set to the start of the year
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Returns a DateTime with the time set to the end of the year
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59);

  /// Returns a DateTime with the time removed (00:00:00)
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns a DateTime with the date part of today and the time part of this DateTime
  DateTime get timeOnly => DateTime.now().startOfDay.add(Duration(hours: hour, minutes: minute, seconds: second));

  /// Returns true if the date is today
  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  /// Returns true if the date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.year == year && yesterday.month == month && yesterday.day == day;
  }

  /// Returns true if the date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.year == year && tomorrow.month == month && tomorrow.day == day;
  }

  /// Returns true if the date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Returns true if the date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Returns a relative time string like "2 hours ago", "Yesterday", etc.
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? 'Yesterday' : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}