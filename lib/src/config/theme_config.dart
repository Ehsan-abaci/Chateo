import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData ligthTheme() => ThemeData(
        primaryColor: ColorManager.neutralActive,
        dividerColor: ColorManager.disabled,
        dividerTheme: DividerThemeData(color: ColorManager.neutralLine),
      );
  static ThemeData darkTheme() => ThemeData(
      primaryColor: ColorManager.primaryColorDark,
      dividerColor: ColorManager.disabled,
      dividerTheme: DividerThemeData(color: ColorManager.neutralDark),
      scaffoldBackgroundColor: ColorManager.neutralActive);
}
