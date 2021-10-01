import 'dart:math';

import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBloc.dart';
import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBlocState.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBloc.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBlocEvent.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBlocState.dart';
import 'package:color_pallete_app/models/ColorPaletteModel.dart';
import 'package:color_pallete_app/views/screens/CreateColorPaletteScreen.dart';
import 'package:color_pallete_app/views/screens/EmpyColorPaletteScreen.dart';
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

  void handleTap({
    required BuildContext context,
    required String id,
    required String title,
    required List<int> colors,
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
                    id: id,
                    title: title,
                    colors: colors,
                  ),
                );
              },
            ),
          ],
          child: CreateColorPaletteScreen(editing: true),
        ),
      ),
    );
  }

  void handleDismiss({
    required BuildContext context,
    required String id,
    required String title,
  }) {
    bloc.add(
      ColorPaletteDelete(id: id, title: title),
    );
  }

  List<Widget> colorCircles({
    required List<int> colors,
  }) {
    List<Widget> list = [];

    for (int i = 0; i < 5; i++) {
      list.add(
        Padding(
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: Color(colors[i]).withAlpha(0xff),
            radius: 10,
          ),
        ),
      );
    }

    return list;
  }

  ListView loadedStateScreen({
    required BuildContext context,
    required LoadedColorPalette state,
  }) {
    return ListView.builder(
      itemCount: state.list.length,
      itemBuilder: (context, index) {
        ColorPalette item = state.list[index];

        return Dismissible(
          key: ValueKey(item),
          direction: DismissDirection.startToEnd,
          onDismissed: (_) => handleDismiss(
            context: context,
            id: item.id,
            title: item.title,
          ),
          background: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  Text('Delete', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          child: ListTile(
            title: Text(
              item.title,
              style: TextStyle(fontSize: 20),
            ),
            trailing: Icon(Icons.edit),
            onTap: () => handleTap(
              context: context,
              id: item.id,
              title: item.title,
              colors: item.colors,
            ),
            contentPadding: EdgeInsets.all(10),
            subtitle: Container(
              child: Row(
                children: colorCircles(colors: item.colors),
              ),
            ),
          ),
        );
      },
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
            return loadedStateScreen(
              context: context,
              state: state,
            );
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
