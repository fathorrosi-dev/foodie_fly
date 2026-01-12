import 'package:flutter/material.dart';

class HelperFunction {
  HelperFunction._();

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static String getGoogleDriveDirectLink(String url) {
    // Ekstrak file ID dari URL Google Drive
    final RegExp regExp = RegExp(r"/d/([a-zA-Z0-9-_]+)");
    final Match? match = regExp.firstMatch(url);

    if (match != null && match.groupCount >= 1) {
      final String fileId = match.group(1)!;
      // Format direct link
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }
    return url;
  }

  static Size scrennSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
