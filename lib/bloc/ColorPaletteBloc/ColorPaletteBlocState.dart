import 'package:color_pallete_app/models/ColorPaletteModel.dart';

abstract class ColorPaletteState {}

class CreatedColorPalette extends ColorPaletteState {
  final String title;
  CreatedColorPalette({required this.title});
}

class LoadingColorPalette extends ColorPaletteState {}

class EmptyColorPalette extends ColorPaletteState {}

class LoadedColorPalette extends ColorPaletteState {
  final List<ColorPalette> list;
  LoadedColorPalette({
    required this.list,
  });
}

class EditedColorPalette extends ColorPaletteState {
  final String title;

  EditedColorPalette({required this.title});
}

class DeletedColorPalette extends ColorPaletteState {
  final String title;

  DeletedColorPalette({
    required this.title,
  });
}

class ErrorStateColorPalette extends ColorPaletteState {
  final String message;
  final String error;

  ErrorStateColorPalette({
    required this.message,
    required this.error,
  });
}
