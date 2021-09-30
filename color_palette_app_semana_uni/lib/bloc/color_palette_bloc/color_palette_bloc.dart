

import 'package:color_palette_app_semana_uni/bloc/color_palette_bloc/color_palette_bloc_events.dart';
import 'package:color_palette_app_semana_uni/bloc/color_palette_bloc/color_palette_bloc_state.dart';
import 'package:color_palette_app_semana_uni/data/color_palette_firebase.dart';
import 'package:color_palette_app_semana_uni/models/color_palette_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorPaletteBloc extends Bloc<ColorPaletteEvent, ColorPaletteState>{
  ColorPaletteBloc(ColorPaletteState initialState) : super(initialState);

  ColorPaletteFirebase colorPaletteFirebase = ColorPaletteFirebase();

 @override
  Stream<ColorPaletteState> mapEventToState(ColorPaletteEvent event) async* {
    switch (event.runtimeType) {
      // Case para receber do firebase todas as paletas cadastradas, e exibi-las na tela principal. 
      case ColorPaletteFetchList:
        yield ColorPaletteLoading();
        List<ColorPalette> colorPaletteList = 
          await colorPaletteFirebase.getColorPalettes();
        if (colorPaletteList.isEmpty) {
          yield ColorPaletteEmptyList();
        }else{
          yield ColorPaletteLoaded(list: colorPaletteList);
        }
        break;
      // Case para quando o evento acionado, for de editar uma paleta selecionada.
      case ColorPaletteEdit:
        event as ColorPaletteEdit;

        try{
          await colorPaletteFirebase.editColorPalette(
            event.colorPalette.id, event.colorPalette.toJson()
          );
          yield ColorPaletteEdited();
        }catch(e){
          print(e.toString());
          yield ColorPaletteErrorState(
            message: 'Erro ao editar os dados no Firebase.'
          );
        }
        break;
      // Case para quando o evento acionado, for de adicionar uma nova paleta.
      case ColorPaletteCreate:
        event as ColorPaletteCreate;

        try{
          final newColorPalette = event.newColorPalette.toJson();
          await colorPaletteFirebase.addColorPalette(newColorPalette);

          yield ColorPaletteAdded();
        }catch(e){
          yield ColorPaletteErrorState(
            message: 'Erro ao adicionar dados ao Firebase.'
          );
        }
        break;
      // Case para quando o evento acionado, for de deletar uma paleta selecionada.
      case ColorPaletteDelete:
        event as ColorPaletteDelete;

        try{
          final idToDelete = event.id;
          await colorPaletteFirebase.removeColorPalette(idToDelete);

          yield ColorPaletteDeleted();
        }catch(e){
          yield ColorPaletteErrorState(
            message: 'Erro ao remover dados ao Firebase.'
          );
        }
        break;
      default:
        throw UnimplementedError();
    }
  }
}