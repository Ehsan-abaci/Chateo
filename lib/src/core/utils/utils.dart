import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade800,
      ),
    );
  }

  static String messageTypeFromExtension(String ext) {
    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') {
      return 'image';
    } else if (ext == 'mp4' || ext == 'mov' || ext == 'mkv') {
      return 'video';
    } else if (ext == 'mp3' || ext == 'wav') {
      return 'audio';
    } else if (ext == 'pdf' || ext == 'doc' || ext == 'docx') {
      return 'doc';
    }
    return 'text';
  }
}
