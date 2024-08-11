import 'package:flutter/material.dart';

class ColorManager {
  static Color neutralActive = HexColor.fromHexColor("#0F1828");
  static Color primaryColorDark = HexColor.fromHexColor("#FFFFFF");
  static Color disabled = HexColor.fromHexColor("#ADB5BD");
  static Color offWhite = HexColor.fromHexColor("#F7F7FC");
  static Color neutralDark = HexColor.fromHexColor("#152033");
  static Color neutralLine = HexColor.fromHexColor("#EDEDED");
  static Color lightBlue = HexColor.fromHexColor("#166FF6");
  static Color darkBlue = HexColor.fromHexColor("#002DE3");
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
