import 'package:flutter/material.dart';

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

extension ToHourMinute on DateTime {
  String toHourMinute() {
    int hour = toLocal().hour;
    int minute = toLocal().minute;
    return " ${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute}";
  }
}
