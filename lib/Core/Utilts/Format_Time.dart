
// date_formatter.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }


  static  Future<DateTime?> selectDeadlineDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now.add(const Duration(days: 3)),
      firstDate: firstDate ?? now,
      lastDate: lastDate ?? DateTime(2100),
    );
    return picked;
  }


  static String formatDateTime(DateTime date, {String format = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(format).format(date);
  }

  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }

  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }

  static String formatDateAuto(DateTime date) {
    final now = DateTime.now();

    // Today
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today, ${DateFormat('HH:mm').format(date)}';
    }

    // Yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday, ${DateFormat('HH:mm').format(date)}';
    }

    // This week
    if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE, HH:mm').format(date);
    }

    // This year
    if (date.year == now.year) {
      return DateFormat('MMM d, HH:mm').format(date);
    }

    // Different year
    return DateFormat('MMM d, yyyy').format(date);
  }
}