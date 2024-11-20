import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/style_manager.dart';
import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData ligthTheme() => ThemeData(
        /// Text theme
        textTheme: TextTheme(
          titleLarge:
              getSemiBoldStyle(color: ColorManager.neutralActive, fontSize: 24),
          titleMedium:
              getMediumStyle(color: ColorManager.neutralActive, fontSize: 14),
          bodySmall:
              getRegularStyle(color: ColorManager.neutralActive, fontSize: 14),
        ),

        ///colors
        primaryColorLight: ColorManager.brandDefault,
        primaryColor: ColorManager.neutralActive,
        dividerColor: ColorManager.disabled,

        /// input theme
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: ColorManager.offWhite,
            border: InputBorder.none,
            hintStyle: getRegularStyle(
              color: ColorManager.disabled,
              fontSize: 14,
            )),

        /// ElevatedButton theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: ColorManager.offWhite,
            backgroundColor: ColorManager.brandDefault,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: ColorManager.brandDefault,
        )),
        // divider theme
        dividerTheme: DividerThemeData(color: ColorManager.neutralLine),
      );

  static ThemeData darkTheme() => ThemeData(
        /// Text theme
        textTheme: TextTheme(
          titleLarge:
              getSemiBoldStyle(color: ColorManager.offWhite, fontSize: 24),
          titleMedium:
              getMediumStyle(color: ColorManager.offWhite, fontSize: 16),
          bodySmall:
              getRegularStyle(color: ColorManager.disabled, fontSize: 14),
        ),

        /// Colors
        primaryColorLight: ColorManager.brandDarkMode,
        primaryColor: ColorManager.offWhite,
        dividerColor: ColorManager.disabled,
        scaffoldBackgroundColor: ColorManager.neutralActive,

        /// Input theme
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: ColorManager.neutralDark,
            border: InputBorder.none,
            hintStyle: getRegularStyle(
              color: ColorManager.disabled,
              fontSize: 14,
            )),

        /// ElevatedButton theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: ColorManager.offWhite,
            backgroundColor: ColorManager.brandDarkMode,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: ColorManager.offWhite,
        )),

        /// Divider theme
        dividerTheme: DividerThemeData(color: ColorManager.neutralDark),
      );
}
