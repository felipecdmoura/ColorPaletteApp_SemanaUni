import 'dart:math';

import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc.dart';
import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc_state.dart';
import 'package:color_palette_app_semana_uni/bloc/color_palette_bloc/color_palette_bloc.dart';
import 'package:color_palette_app_semana_uni/views/create_color_palette_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyListScreen extends StatelessWidget {
  const EmptyListScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 100),
          child: Text(
            "Você ainda não tem nenhuma paleta de cores",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_){
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: BlocProvider.of<ColorPaletteBloc>(context),
                      ),

                      BlocProvider<ColorFormBloc>(
                        create: (_) => ColorFormBloc(
                          ColorFormState(
                            //sem id, pois e uma nova paleta
                            id: '', 
                            title: 'Nova Paleta', 
                            colors: List.generate(5, (index) => Random().nextInt(0xffffffff))
                          )
                        ))
                    ],
                    child: CreateColorPaletteScreen(editing: false),
                  );
                })
              );
            },
            child: const Text(
              "Crie uma Agora!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),  
        ),
      ],
    );
  }
}