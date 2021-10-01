import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBloc.dart';
import 'package:color_pallete_app/bloc/ColorFormBloc/ColorFormBlocEvent.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBloc.dart';
import 'package:color_pallete_app/bloc/ColorPaletteBloc/ColorPaletteBlocEvent.dart';
import 'package:color_pallete_app/models/ColorPaletteModel.dart';
import 'package:color_pallete_app/views/components/ColorBoxComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateColorPaletteScreen extends StatefulWidget {
  final bool editing;

  const CreateColorPaletteScreen({Key? key, required this.editing})
      : super(key: key);

  @override
  _CreateColorPaletteScreenState createState() =>
      _CreateColorPaletteScreenState();
}

class _CreateColorPaletteScreenState extends State<CreateColorPaletteScreen> {
  final TextEditingController _controller = TextEditingController();
  late ColorFormBloc colorFormBloc;

  double getScreenHeight(AppBar appBar) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    double height = mediaQuery.size.height;
    double appBarHeight = appBar.preferredSize.height;
    double paddingTop = mediaQuery.padding.top;

    return height - appBarHeight - paddingTop;
  }

  void saveNewColorPalette({
    required String title,
    required List<int> colors,
  }) {
    BlocProvider.of<ColorPaletteBloc>(context).add(
      ColorPaletteCreate(
        colorPalette: ColorPalette(
          id: '',
          title: title,
          colors: colors,
        ),
      ),
    );
  }

  void editColorPalette({
    required String id,
    required String title,
    required List<int> colors,
  }) {
    BlocProvider.of<ColorPaletteBloc>(context).add(
      ColorPaletteUpdate(
        colorPalette: ColorPalette(
          id: id,
          title: title,
          colors: colors,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colorFormBloc = BlocProvider.of<ColorFormBloc>(context);

    _controller.text = colorFormBloc.state.title;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );

    AppBar appBar = AppBar(
      title: Text('Nova paleta de cores'),
      centerTitle: true,
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          height: getScreenHeight(appBar),
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                controller: _controller,
                onChanged: (value) {
                  colorFormBloc.add(
                    ChangeColorFormEvent(
                      id: colorFormBloc.state.id,
                      index: -1,
                      title: value,
                      colors: colorFormBloc.state.colors,
                    ),
                  );
                },
              ),
              Column(
                children: [
                  for (int i = 0; i < 5; i++) ColorBoxComponent(index: i)
                ],
              ),
              IconButton(
                alignment: Alignment.center,
                icon: Icon(Icons.refresh),
                color: Colors.black,
                iconSize: 80,
                onPressed: () {
                  colorFormBloc.add(
                    RandomizeColorFormEvent(
                      id: colorFormBloc.state.id,
                      title: colorFormBloc.state.title,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  child: Text('SALVAR'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () {
                    final state = colorFormBloc.state;

                    if (this.widget.editing == true) {
                      editColorPalette(
                        id: state.id,
                        title: state.title,
                        colors: state.colors,
                      );
                    } else {
                      saveNewColorPalette(
                        title: _controller.text,
                        colors: state.colors,
                      );
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
