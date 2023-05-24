



import 'package:flutter/material.dart';

const  Color redColor = Color(0xFFF04A37);
const  Color lightRedColor = Color(0xFFF86555);
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