import 'dart:ffi';
import 'dart:math';

import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc.dart';
import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc_state.dart';
import 'package:color_palette_app_semana_uni/bloc/color_palette_bloc/color_palette_bloc.dart';
import 'package:color_palette_app_semana_uni/bloc/color_palette_bloc/color_palette_bloc_events.dart';
import 'package:color_palette_app_semana_uni/bloc/color_palette_bloc/color_palette_bloc_state.dart';
import 'package:color_palette_app_semana_uni/views/create_color_palette_screen.dart';
import 'package:color_palette_app_semana_uni/views/empty_color_palette_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Pagina inicial, quando ao menos uma paleta esta adicionada.
class ListColorPalettes extends StatefulWidget {
  const ListColorPalettes({Key? key}) : super(key: key);

  @override
  _ListColorPalettesState createState() => _ListColorPalettesState();
}

class _ListColorPalettesState extends State<ListColorPalettes> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ColorPaletteBloc>(context).add(ColorPaletteFetchList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suas Paletas de Cores',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<ColorPaletteBloc>(
                      context), //Passa o Bloc ColorPaletteBloc do main para esta tela
                ),

                //Gera o bloc ColorFormBloc, a ser usado na criacao de novas paletas
                BlocProvider<ColorFormBloc>(
                  create: (_) => ColorFormBloc(
                      //Sem id pois e uma nova paleta sendo gerada
                      ColorFormState(
                          id: '',
                          colors: List.generate(
                              5,
                              (index) => Random().nextInt(
                                  0xffffffff)), //Gera uma lista de cores aleatorias
                          title: 'Nova Paleta')),
                )
              ],
              child: CreateColorPaletteScreen(editing: false), // editing vai como false, foi estamos criando uma paleta nova, nao editando uma nova.
            );
          }));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<ColorPaletteBloc, ColorPaletteState>(
        builder: (context, state) {
          ColorPaletteBloc bloc = BlocProvider.of<ColorPaletteBloc>(context);
          if (state is ColorPaletteLoading) {
            return const CircularProgressIndicator(
              color: Colors.black,
            );
          } else if (state is ColorPaletteLoaded) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                //Gera uma lista com capacidade de swipe usada, no caso, para remocao da paleta 
                return Dismissible(
                  key: Key(state.list[index].id),
                  //Chama o metodo ao realizar o swipe da paleta
                  onDismissed: (_) {
                    removeColorPalette(state.list[index].id);
                    // Mostra uma snackbar dizendo que a paleta foi deletada.
                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('"${state.list[index].title}" deletada!')));
                  },
                  //Fundo que aparece durante o swipe 
                  background: Container(color: Colors.grey),
                  child: ListTile(
                    title: Text(
                      state.list[index].title,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    trailing: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    tileColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) {
                          return MultiBlocProvider(providers: [
                            BlocProvider.value(
                                value:
                                    BlocProvider.of<ColorPaletteBloc>(context)),
                            BlocProvider<ColorFormBloc>(create: (context) {
                              List<int> paletteColorList =
                                  state.list[index].colors;
                              String paletteTitle = state.list[index].title;
                              String paletteId = state.list[index].id;

                              return ColorFormBloc(ColorFormState(
                                  colors: paletteColorList,
                                  title: paletteTitle,
                                  id: paletteId));
                            }),
                          ], child: CreateColorPaletteScreen(editing: true));// Editing vai como true, pois estamos editando uma paleta existente.
                        },
                      ));
                    },
                    contentPadding: EdgeInsets.all(10),
                    subtitle: Container(
                      child:
                          Row(children: colorCircles(state.list[index].colors)),
                    ),
                  ),
                );
              },
            );
          } else if (state is ColorPaletteAdded || state is ColorPaletteEdited || state is ColorPaletteDeleted) {
            bloc.add(ColorPaletteFetchList());
            return Container();
          } else if (state is ColorPaletteEmptyList) {
            return const EmptyListScreen();
          } else if (state is ColorPaletteErrorState) {
            return Text(state.message);
          } else {
            print("Estado nao Implementado!");
            return Container();
          }
        },
      ),
    );
  }

  // Metodo para gerar os circulos com as cores da paleta, abaixo do nome.
  List<Widget> colorCircles(List<int> colors) {
    List<Widget> circleslist = [];

    for (var i = 0; i < 5; i++) {
      Widget circle = Padding(
        padding: const EdgeInsets.all(5),
        child: CircleAvatar(
            backgroundColor: Color(colors[i]).withAlpha(0xff), radius: 10),
      );
      circleslist.add(circle);
    }

    return circleslist;
  }

  //Metodo para remover as paletas ao deslizar
  void removeColorPalette(String id) {
    BlocProvider.of<ColorPaletteBloc>(context).add(ColorPaletteDelete(id: id));
  }
}
