import 'package:flutter/material.dart';

const  Color redColor = Color(0xFFF04A37);
const  Color lightRedColor = Color(0xFFF86555);
const  Color darkRedColor = Color(0xFFC91616);
const  Color lightGray = Color(0xFFF9F9F9);
const  Color whiteColor = Colors.white;
const  Color blackColor = Colors.black;
const Color normalGray = Color(0xFFB3AAAA);
const Color darkGray = Color(0xFF5D5D5D);



class AppTheme{
  static final lightTheme = ThemeData(
      colorScheme: const ColorScheme.light(
        primary: redColor,
        secondary: redColor,
        background: lightGray,
        secondaryContainer: whiteColor,
        onSecondaryContainer: normalGray,
      )
  );

  static final pieChartColors = [
    const Color(0xFF2B6373),
    const Color(0xFF5388D8),
    const Color(0xFFFF9F40),
    const Color(0xFFE8978E),
    const Color(0xFF91E88E),
    const Color(0xFFD58EE8),
    const Color(0xFF8EDBE8),
    const Color(0xFFD715C3),
    const Color(0xFFFC505E),
    const Color(0xFFBFE51D),
    const Color(0xFF04A850),
    const Color(0xFF04A88A),
    const Color(0xFF725F5F),
    const Color(0xFFDED86C),
    const Color(0xFF857219),
    const Color(0xFF4B047A),
    const Color(0xFFD52C2C),
  ];
}

class AppTextTheme{
  static const logoTextStyle = TextStyle(
    fontSize: 42,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.bold,
    color: redColor
  );

  static const hintTextStyle = TextStyle(
      fontSize: 14,
      fontFamily: 'Tajawal',
    color: normalGray
  );

  static const appBarTitleTextStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.bold,
    color: redColor,
  );

  static const textButtonStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Tajawal',
      color: blackColor,
  );

  static const headerTextStyle = TextStyle(
    fontSize: 13,
    fontFamily: 'Tajawal',
    color: darkGray,
    fontWeight: FontWeight.bold
  );

  static const elevatedButtonTextStyle = TextStyle(
      fontSize: 14,
      fontFamily: 'Tajawal',
      fontWeight: FontWeight.bold,
      color: whiteColor,
  );

  static const normalTextStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.normal,
    color: blackColor,
  );


}