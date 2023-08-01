import 'package:flutter/material.dart';

//LightThemeColors
const Color orangeyRed = Color(0xFFF04A37);
const Color redBrown = Color(0xFFA81B1B); // for card linear effect
const Color snowDrift = Color(0xFFF9F9F9); // for light background
const Color lightGrey = Color(0xFFB3AAAA); // for hints and headers
const Color darkGrey = Color(0xFF1D1D1D);
const Color black = Color(0xFF121212);
const Color white = Color(0xFFFFFFFF);
const Color red = Color(0xFFFF0000);
const Color green = Color(0xFF23D614);

// const  Color redColor = Color(0xFFF04A37);
// const  Color lightRedColor = Color(0xFFF86555);
// const  Color darkRedColor = Color(0xFFC91616);
// const  Color lightGray = Color(0xFFF9F9F9);
// const  Color whiteColor = Colors.white;
// const  Color blackColor = Colors.black;
// const Color normalGray = Color(0xFFB3AAAA);
// const Color darkGray = Color(0xFF5D5D5D);



class AppTheme{
  static final lightTheme = ThemeData(
      colorScheme: const ColorScheme.light(
        background: snowDrift,
        onBackground: white,
        primary: orangeyRed,
        secondary: lightGrey, //textColor on home screen
        onPrimary: black , // textColor on onBoarding
        onSecondary: orangeyRed,
        onPrimaryContainer: white, // for textFiled background
        surface: white,
      )
  );

  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      background: black,
      onBackground: darkGrey, // for BS background color
      primary: orangeyRed,
      secondary: lightGrey,
      onPrimary: lightGrey,
      onSecondary: lightGrey,
      onPrimaryContainer: darkGrey, // textColor of auth screen
      surface: black  ,
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
    fontSize: 24,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.bold,
  );

  static const hintTextStyle = TextStyle(
      fontSize: 14,
      fontFamily: 'Tajawal',
    color: lightGrey
  );

  static const appBarTitleTextStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.bold,
  );

  static const textButtonStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Tajawal',
  );

  static const headerTextStyle = TextStyle(
    fontSize: 13,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.bold,
    color: lightGrey,
  );

  static const elevatedButtonTextStyle = TextStyle(
      fontSize: 14,
      fontFamily: 'Tajawal',
      fontWeight: FontWeight.bold,
      color: white,
  );

  static const normalTextStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.normal,
  );


}