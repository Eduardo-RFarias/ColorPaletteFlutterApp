import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBloc.dart';
import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBlocEvent.dart';
import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBlocState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorBoxComponent extends StatelessWidget {
  final int index;
  const ColorBoxComponent({Key? key, required this.index}) : super(key: key);

  Color invertColor(Color entrycolor) {
    double middle = entrycolor.red * 0.299 +
        entrycolor.green * 0.587 +
        entrycolor.blue * 0.114;

    if (middle > 150) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorFormBloc, ColorFormState>(
      builder: (context, state) {
        final color = Color(state.colors[index]).withAlpha(0xff);

        return Container(
          padding: EdgeInsets.all(10),
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R:  ${color.red} G:  ${color.green} B:  ${color.blue} \nHash: #${color.hashCode.toRadixString(16)}',
                style: TextStyle(
                  fontSize: 18,
                  color: invertColor(color),
                ),
              ),
              IconButton(
                onPressed: () {
                  BlocProvider.of<ColorFormBloc>(context).add(
                    ChangeColorFormEvent(
                      id: state.id,
                      index: index,
                      title: state.title,
                      colors: state.colors,
                    ),
                  );
                },
                icon: Icon(
                  Icons.refresh,
                  color: invertColor(color),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
