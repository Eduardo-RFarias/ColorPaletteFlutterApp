import 'package:flutter/material.dart';

class ColorFormState {
  String id;
  String title;
  late List<Color> colors;

  ColorFormState({
    required this.id,
    required this.title,
    required this.colors,
  });
}
