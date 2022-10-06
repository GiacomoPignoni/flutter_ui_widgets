import 'package:flutter/material.dart';

const paperWhite = Color(0xFFF9FBFF); 
const pencilBlack = Color(0xFF5F6368);
const lightGrey = Color(0xFFC4C4C4);

final theme = ThemeData(
  fontFamily: "Poppins",
  scaffoldBackgroundColor: paperWhite,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: pencilBlack,
    onPrimary: paperWhite,
    secondary: lightGrey,
    onSecondary: pencilBlack,
    error: Colors.red,
    onError: Colors.white,
    background: paperWhite,
    onBackground: pencilBlack,
    surface: paperWhite,
    onSurface: pencilBlack, 
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      color: pencilBlack,
      fontSize: 16
    ),
    headline3: TextStyle(
      color: pencilBlack,
      fontWeight: FontWeight.w500,
      fontSize: 18
    ),
  ),
  iconTheme: const IconThemeData(
    color: pencilBlack,
    size: 20,
    opacity: 1,
  ),
  appBarTheme: AppBarTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    backgroundColor: paperWhite,
    elevation: 2,
    iconTheme: const IconThemeData(
      color: pencilBlack,
    ),
    centerTitle: true,
    titleTextStyle: const TextStyle(
      color: pencilBlack,
      fontSize: 20,
      fontWeight: FontWeight.w500
    )
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  )
);
