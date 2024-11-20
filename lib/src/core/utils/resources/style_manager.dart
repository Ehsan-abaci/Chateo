import 'package:flutter/material.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle getRegularStyle({double fontSize = 12, @required Color? color}) {
  return _getTextStyle(
    fontSize,
    FontWeight.w400,
    color!,
  );
}

TextStyle getMediumStyle({double fontSize = 12, @required Color? color}) {
  return _getTextStyle(
    fontSize,
    
    FontWeight.w500,
    color!,
  );
}

TextStyle getSemiBoldStyle({double fontSize = 12, @required Color? color}) {
  return _getTextStyle(
    fontSize,
    FontWeight.w600,
    color!,
  );
}

TextStyle getBoldStyle({double fontSize = 12, @required Color? color}) {
  return _getTextStyle(
    fontSize,
    FontWeight.w700,
    color!,
  );
}
