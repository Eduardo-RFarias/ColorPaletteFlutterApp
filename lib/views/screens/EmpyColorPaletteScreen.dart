import 'dart:math';

import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBloc.dart';
import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBlocState.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBloc.dart';
import 'package:color_pallete_app/views/screens/CreateColorPaletteScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyColorPaletteScreen extends StatelessWidget {
  const EmptyColorPaletteScreen({Key? key}) : super(key: key);

  void handleTap({
    required BuildContext context,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<ColorPaletteBloc>(context),
            ),
            BlocProvider<ColorFormBloc>(
              create: (context) {
                return ColorFormBloc(
                  initialState: ColorFormState(
                    id: '',
                    title: 'Nova Paleta',
                    colors: List.generate(
                        5, (index) => Random().nextInt(0xFFFFFFFF)),
                  ),
                );
              },
            ),
          ],
          child: CreateColorPaletteScreen(
            editing: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 100),
          child: Text(
            'Você ainda não tem nenhuma \n paleta de cores :(',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: GestureDetector(
            onTap: () => handleTap(context: context),
            child: Text(
              'Experimente criar uma\n agora!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
