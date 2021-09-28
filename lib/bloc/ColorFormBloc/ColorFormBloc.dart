import 'dart:math';

import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBlocEvent.dart';
import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBlocState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorFormBloc extends Bloc<ColorFormEvent, ColorFormState> {
  ColorFormBloc({required ColorFormState initialState}) : super(initialState);

  @override
  Stream<ColorFormState> mapEventToState(ColorFormEvent event) async* {
    //! Mudar uma cor
    if (event is ChangeColorFormEvent) {
      ColorFormState state = ColorFormState(
        id: event.id,
        title: event.title,
        colors: event.colors,
      );

      Color newColor = Color(Random().nextInt(0xffffffff));

      if (event.index >= 0) {
        state.colors[event.index] = newColor;
      }

      yield state;
    }
    //! Randomizar todas as cores
    else if (event is RandomizeColorFormEvent) {
      List<Color> randomColors = List.generate(5, (index) {
        return Color(Random().nextInt(0xffffffff));
      });

      ColorFormState state = ColorFormState(
        id: event.id,
        title: event.title,
        colors: randomColors,
      );

      yield state;
    }
    //! Caso algum bug desconhecido ocorra quanto aos tipos
    else {
      Exception('A classe requisitada não existe em BlocEvent... ' +
          'Algum problema ocorreu, o código não deveria chegar aqui');
    }
  }
}
