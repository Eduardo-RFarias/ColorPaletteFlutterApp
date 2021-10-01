import 'dart:math';

import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBloc.dart';
import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBlocState.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBloc.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBlocEvent.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBlocState.dart';
import 'package:color_pallete_app/views/screens/CreateColorPaletteScreen.dart';
import 'package:color_pallete_app/views/screens/EmpyColorPaletteScreen.dart';
import 'package:color_pallete_app/views/screens/ListedColorPaletteScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorPalettesScreen extends StatefulWidget {
  const ColorPalettesScreen({Key? key}) : super(key: key);

  @override
  _ColorPalettesScreenState createState() => _ColorPalettesScreenState();
}

class _ColorPalettesScreenState extends State<ColorPalettesScreen> {
  late ColorPaletteBloc bloc;

  @override
  void initState() {
    BlocProvider.of<ColorPaletteBloc>(context).add(ColorPaletteRetrieve());
    super.initState();
  }

  void handleAdd({
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
              create: (_) => ColorFormBloc(
                initialState: ColorFormState(
                  id: '',
                  title: 'Nova Paleta',
                  colors:
                      List.generate(5, (index) => Random().nextInt(0xffffffff)),
                ),
              ),
            )
          ],
          child: CreateColorPaletteScreen(
            editing: false,
          ),
        ),
      ),
    );
  }

  void showSnackBar(String text) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ColorPaletteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Suas paletas de cores'),
        centerTitle: true,
        elevation: 10,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => handleAdd(context: context),
      ),
      body: BlocBuilder<ColorPaletteBloc, ColorPaletteState>(
        builder: (context, state) {
          //! Estado de loading
          if (state is LoadingColorPalette) {
            return Center(child: CircularProgressIndicator());
          }
          //! Estado de carregado
          else if (state is LoadedColorPalette) {
            return ListedColorPaletteScreen();
          }
          //! Estado de paleta criada
          else if (state is CreatedColorPalette) {
            showSnackBar('A paleta "${state.title}" foi criada');

            bloc.add(ColorPaletteRetrieve());

            return Container();
          }
          //! Estado de algo foi modificado
          else if (state is EditedColorPalette) {
            showSnackBar('A paleta "${state.title}" foi editada"');

            bloc.add(ColorPaletteRetrieve());

            return Container();
          }
          //! Estado de algo foi deletado
          else if (state is DeletedColorPalette) {
            showSnackBar('A paleta "${state.title}" foi deletada');

            bloc.add(ColorPaletteRetrieve());

            return Container();
          }
          //! Estado de lista vazia
          else if (state is EmptyColorPalette) {
            return EmptyColorPaletteScreen();
          }
          //! Estado de Erro
          else if (state is ErrorStateColorPalette) {
            return Center(
              child: Text(
                '${state.message}\n' + '${state.error}',
                style: TextStyle(fontSize: 30, color: Colors.red),
              ),
            );
          }
          //! Caso apareça um estado não implementado
          else {
            throw Exception('Foi passado um estado não implementado: ' +
                state.runtimeType.toString());
          }
        },
      ),
    );
  }
}
