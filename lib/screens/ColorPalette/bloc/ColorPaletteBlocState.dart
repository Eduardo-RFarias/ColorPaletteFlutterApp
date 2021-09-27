import 'package:color_pallete_app/models/ColorPaletteModel.dart';

abstract class ColorPaletteState {}

class CreatedColorPalette extends ColorPaletteState {}

class LoadingColorPalette extends ColorPaletteState {}

class EmptyColorPalette extends ColorPaletteState {}

class LoadedColorPalette extends ColorPaletteState {
  final List<ColorPalette> list;
  LoadedColorPalette({
    required this.list,
  });
}

class EditedColorPalette extends ColorPaletteState {}

class DeletedColorPalette extends ColorPaletteState {}

class ErrorStateColorPalette extends ColorPaletteState {
  final String message;
  final String error;

  ErrorStateColorPalette({
    required this.message,
    required this.error,
  });
}
