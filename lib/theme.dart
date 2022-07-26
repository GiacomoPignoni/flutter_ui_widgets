import 'package:flutter/material.dart';

const paperWhite = Color(0xFFF9FBFF); 
const lightBlack = Color(0xFF5F6368);
const pencilBlue = Color(0xFF5C6274);
const lightGrey = Color(0xFFC4C4C4);

final theme = ThemeData(
  fontFamily: "Montserrat",
  scaffoldBackgroundColor: paperWhite,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: lightBlack,
    onPrimary: paperWhite,
    secondary: lightGrey,
    onSecondary: lightBlack,
    error: Colors.red,
    onError: Colors.white,
    background: paperWhite,
    onBackground: lightBlack,
    surface: paperWhite,
    onSurface: lightBlack, 
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      color: lightBlack,
      fontSize: 16
    ),
    headline3: TextStyle(
      color: lightBlack,
      fontWeight: FontWeight.bold,
      fontSize: 18
    ),
  ),
  iconTheme: const IconThemeData(
    color: lightBlack,
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
      color: lightBlack,
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
