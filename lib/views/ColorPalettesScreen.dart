import 'package:flutter/material.dart';

class ColorPalettesScreen extends StatelessWidget {
  const ColorPalettesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Palette App'),
      ),
      body: Center(
        child: Text('Olá mundo!'),
      ),
    );
  }
}
