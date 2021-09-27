import 'package:color_pallete_app/models/ColorPaletteModel.dart';

abstract class ColorPaletteEvent {}

class ColorPaletteCreate extends ColorPaletteEvent {
  final ColorPalette colorPalette;

  ColorPaletteCreate({
    required this.colorPalette,
  });
}

class ColorPaletteRetrieve extends ColorPaletteEvent {}

class ColorPaletteUpdate extends ColorPaletteEvent {
  final ColorPalette colorPalette;

  ColorPaletteUpdate({
    required this.colorPalette,
  });
}

class ColorPaletteDelete extends ColorPaletteEvent {
  final String id;

  ColorPaletteDelete({
    required this.id,
  });
}
