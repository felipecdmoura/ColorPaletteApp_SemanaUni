import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc.dart';
import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc_events.dart';
import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorField extends StatelessWidget {
  final int index;
  const ColorField({ Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorFormBloc, ColorFormState>(
      builder: (context, state){
        Color color = Color(state.colors[index]).withAlpha(0xff);
        var brightness = (0.299 * color.red) + (0.587 * color.green) + (0.114 * color.blue); //Funcao para saber a claridade da cor, para colocar um texto claro para melhor vizualizacao.
        //Identifica a claridade da cor e define se o texto sera branco ou preto
        if (brightness < 50) {
          return Container(
            padding: EdgeInsets.all(10),
            //color: color,
            width: 370,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(40))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R: ${color.red} G: ${color.green} B: ${color.blue}', 
                  style: TextStyle(fontSize: 18, color: Colors.white) //Cor branca para o texto caso a cor da paleta seja mais escura
                ),
                IconButton(
                  onPressed: (){
                    BlocProvider.of<ColorFormBloc>(context).add(ChangeColorFormEvents(
                      id: state.id, 
                      title: state.title, 
                      colors: state.colors, 
                      index: index)
                    );
                  }, 
                  icon: Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          );
        }else{
          return Container(
            padding: EdgeInsets.all(10),
            //color: color,
            width: 370,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(40))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R: ${color.red} G: ${color.green} B: ${color.blue}', 
                  style: TextStyle(fontSize: 18, color: Colors.black), //Cor do texto preta para cores mais claras
                ),
                IconButton(
                  onPressed: (){
                    BlocProvider.of<ColorFormBloc>(context).add(ChangeColorFormEvents(
                      id: state.id, 
                      title: state.title, 
                      colors: state.colors, 
                      index: index)
                    );
                  }, 
                  icon: Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          );
        }
      },
    );
  }
} 