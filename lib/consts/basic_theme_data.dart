import 'package:flutter/material.dart';

ThemeData basicThemeData() {
  return ThemeData(
    fontFamily: 'NanumSquareRoundMedium',
    colorScheme: const ColorScheme.light(
      primary: Color(0xfff9e400),
      secondary: Color(0xffFFAF00),
      onPrimary: Color(0xff303030),
    ),
  );
}
