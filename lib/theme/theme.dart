import 'package:flutter/material.dart';

abstract class MyTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.black,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      primaryColor: Colors.black,
      accentColor: Colors.white,
    );
  }
}
