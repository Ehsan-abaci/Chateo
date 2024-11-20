import 'package:flutter/material.dart';

class ColorManager {
  static Color neutralActive = HexColor.fromHexColor("#0F1828");
  static Color disabled = HexColor.fromHexColor("#ADB5BD");
  static Color offWhite = HexColor.fromHexColor("#F7F7FC");
  static Color neutralDark = HexColor.fromHexColor("#152033");
  static Color neutralLine = HexColor.fromHexColor("#EDEDED");
  static Color lightBlue = HexColor.fromHexColor("#166FF6");
  static Color brandDefault = HexColor.fromHexColor("#002DE3");
  static Color brandLight = HexColor.fromHexColor("#879FFF");
  static Color brandDarkMode = HexColor.fromHexColor("#375FFF");
  static Color brandDark = HexColor.fromHexColor("#001A83");
  static Color brandBg = HexColor.fromHexColor("#D2D5F9");
}

extension HexColor on Color {
  static Color fromHexColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
