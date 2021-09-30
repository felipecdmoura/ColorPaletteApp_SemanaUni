import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc_events.dart';
import 'package:color_palette_app_semana_uni/bloc/color_form_bloc/color_form_bloc_state.dart';

class ColorFormBloc extends Bloc<ColorFormEvents, ColorFormState>{
  ColorFormBloc(ColorFormState initialState) : super(initialState);

  @override
  Stream<ColorFormState> mapEventToState(ColorFormEvents event) async*{
    switch (event.runtimeType) {
      // Case para quando se randomiza apenas uma das cores da paleta.
      case ChangeColorFormEvents :
        event as ChangeColorFormEvents;

        ColorFormState state = ColorFormState(
          id: event.id, title: event.title, colors: event.colors);

        int newColor = Random().nextInt(0xffffffff);

        if(event.index >= 0){
          state.colors[event.index] = newColor;
        }
        yield state;
        break;
      // Case para quando se randomiza todas as cores de uma paleta.
      case RandomizeColorFormEvents:
        event as RandomizeColorFormEvents;

        List<int> newRandomColors = List.generate(5, (index) => Random().nextInt(0xffffffff));

        ColorFormState state = ColorFormState(id: event.id, title: event.title, colors: newRandomColors);

        yield state;
        break;
      default:
        throw UnimplementedError();
    }
  }
}