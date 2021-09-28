import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBlocEvent.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBlocState.dart';
import 'package:color_pallete_app/data/firebase/ColorPaletteFirebase.dart';
import 'package:color_pallete_app/models/ColorPaletteModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorPaletteBloc extends Bloc<ColorPaletteEvent, ColorPaletteState> {
  final ColorPaletteFirebase colorPaletteFirebase;

  ColorPaletteBloc({required ColorPaletteState initialState})
      : colorPaletteFirebase = ColorPaletteFirebase(),
        super(initialState);

  @override
  Stream<ColorPaletteState> mapEventToState(ColorPaletteEvent event) async* {
    //! Criar uma nova paleta
    if (event is ColorPaletteCreate) {
      try {
        await colorPaletteFirebase.addColorPalette(
          json: event.colorPalette.toJson(),
        );
        yield CreatedColorPalette();
      } catch (error) {
        yield ErrorStateColorPalette(
          message: 'Erro ao adicionar dados ao Firebase',
          error: error.toString(),
        );
      }
    }
    //! Recuperar paletas cadastradas
    else if (event is ColorPaletteRetrieve) {
      yield LoadingColorPalette();

      try {
        List<ColorPalette> colorPaletteList =
            await this.colorPaletteFirebase.retrieveColorPalettes();
        yield (colorPaletteList.isEmpty)
            ? EmptyColorPalette()
            : LoadedColorPalette(list: colorPaletteList);
      } catch (error) {
        yield ErrorStateColorPalette(
          message: 'Erro ao recuperar dados do Firebase',
          error: error.toString(),
        );
      }
    }
    //! Editar uma paleta
    else if (event is ColorPaletteUpdate) {
      try {
        await colorPaletteFirebase.updateColorPalette(
          id: event.colorPalette.id,
          json: event.colorPalette.toJson(),
        );
        yield EditedColorPalette();
      } catch (error) {
        yield ErrorStateColorPalette(
          message: 'Erro ao editar dados do Firebase',
          error: error.toString(),
        );
      }
    }
    //! Deletar uma paleta
    else if (event is ColorPaletteDelete) {
      try {
        await colorPaletteFirebase.deleteColorPalette(
          id: event.id,
        );
        yield DeletedColorPalette();
      } catch (error) {
        yield ErrorStateColorPalette(
          message: 'Erro ao apagar dados do Firebase',
          error: error.toString(),
        );
      }
    }
    //! Caso algum bug desconhecido ocorra quanto aos tipos
    else {
      throw Exception('A classe requisitada não existe em BlocEvent... ' +
          'Algum problema ocorreu, o código não deveria chegar aqui');
    }
  }
}
