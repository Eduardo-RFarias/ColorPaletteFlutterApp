import 'package:flutter/material.dart';

abstract class MyTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      primarySwatch: Colors.teal,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
    );
  }
}
