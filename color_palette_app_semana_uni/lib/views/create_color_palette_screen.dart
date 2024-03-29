import 'dart:ui';

import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc.dart';
import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc_events.dart';
import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc_state.dart';
import 'package:color_palette_app_semana_uni/bloc/color_palette_bloc/color_palette_bloc.dart';
import 'package:color_palette_app_semana_uni/bloc/color_palette_bloc/color_palette_bloc_events.dart';
import 'package:color_palette_app_semana_uni/models/color_palette_model.dart';
import 'package:color_palette_app_semana_uni/views/color_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateColorPaletteScreen extends StatefulWidget {

  final bool editing;
  CreateColorPaletteScreen({ required this.editing});

  @override
  _CreateColorPaletteScreenState createState() => _CreateColorPaletteScreenState();
}

class _CreateColorPaletteScreenState extends State<CreateColorPaletteScreen> {
  final TextEditingController _controller = TextEditingController();
  late ColorFormBloc colorFormBloc;

  @override
  Widget build(BuildContext context) {
    colorFormBloc = BlocProvider.of<ColorFormBloc>(context);
    _controller.text = colorFormBloc.state.title;
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    AppBar appBar = 
      AppBar(
        title: const Text('Nova Paleta de Cores',style: TextStyle(color: Colors.black)), 
        centerTitle: true, 
        elevation: 10, 
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
      );
    double screenHeight = MediaQuery.of(context).size.height - 
      appBar.preferredSize.height - 
      MediaQuery.of(context).padding.top - 10;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          alignment: Alignment.bottomCenter,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextField(
              textAlign: TextAlign.center,
              controller: _controller,
              onChanged: (value){
                colorFormBloc.add(ChangeColorFormEvents(
                  id: colorFormBloc.state.id, 
                  title: value, 
                  colors: colorFormBloc.state.colors, 
                  index: -1)//E -1, pois estamos alterando apenas o titulo, e nao uma paleta
                );
              },
            ),
            Column(
              children: [
                for (int i = 0; i < 5; i++) ColorField(index: i)
              ],
            ),

            IconButton(
              alignment: Alignment.center,
              onPressed: (){
                colorFormBloc.add(RandomizeColorFormEvents(
                  id: colorFormBloc.state.id, 
                  title: colorFormBloc.state.title)
                );
              }, 
              icon: const Icon(Icons.replay_circle_filled),
              color: Colors.black,
              iconSize: 80,
            ),
            SizedBox(
              height: 90,
              width: 350,
              child: ElevatedButton(
                onPressed: (){
                  widget.editing ? editExistingColorPalette(colorFormBloc.state) : saveNewColorPalette(colorFormBloc.state);
                  Navigator.of(context).pop();

                 
                },
                child: Text("Salvar"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.black),
                  )
                ),
              ),
            ),
          ],
          )
        ),
      ),
    );
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }



  void editExistingColorPalette(ColorFormState state) {
    final newColorPalette = ColorPalette(id: state.id, colors: state.colors, title: state.title);

    ColorPaletteBloc colorPaletteBloc = BlocProvider.of<ColorPaletteBloc>(context);

    colorPaletteBloc.add(ColorPaletteEdit(newColorPalette));

    // Mostra uma snackbar dizendo que a paleta foi editada.
    ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('"${colorFormBloc.state.title}" editada!')));
  }

  void saveNewColorPalette(ColorFormState state) {
    List<int> colors = colorFormBloc.state.colors;
    final newColorPalette = ColorPalette(id: '', colors: colors, title: _controller.text);

    BlocProvider.of<ColorPaletteBloc>(context).add(ColorPaletteCreate(newColorPalette));

    // Mostra uma snackbar dizendo que a paleta foi adicionada.
    ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('"${colorFormBloc.state.title}" adicionada!')));
  }
}