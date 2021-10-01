import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBloc.dart';
import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBlocState.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBloc.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBlocEvent.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBlocState.dart';
import 'package:color_pallete_app/models/ColorPaletteModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CreateColorPaletteScreen.dart';

class ListedColorPaletteScreen extends StatelessWidget {
  const ListedColorPaletteScreen({Key? key}) : super(key: key);

  void handleTap({
    required String id,
    required String title,
    required List<int> colors,
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
    required String id,
    required String title,
    required BuildContext context,
    required ColorPaletteBloc bloc,
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

  @override
  Widget build(BuildContext context) {
    ColorPaletteBloc bloc = BlocProvider.of<ColorPaletteBloc>(context);
    return BlocBuilder<ColorPaletteBloc, ColorPaletteState>(
        builder: (context, state) {
      state as LoadedColorPalette;
      return ListView.builder(
        itemCount: state.list.length,
        itemBuilder: (context, index) {
          ColorPalette item = state.list[index];

          return Dismissible(
            key: ValueKey(item),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) => handleDismiss(
              id: item.id,
              title: item.title,
              context: context,
              bloc: bloc,
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
                id: item.id,
                title: item.title,
                colors: item.colors,
                context: context,
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
    });
  }
}
