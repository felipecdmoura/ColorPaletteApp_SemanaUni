import 'package:color_palette_app_semana_uni/models/color_palette_model.dart';

abstract class ColorPaletteState {}

class ColorPaletteLoading extends ColorPaletteState{}

class ColorPaletteLoaded extends ColorPaletteState{
  final List<ColorPalette> list;

  ColorPaletteLoaded({required this.list});
}

class ColorPaletteEmptyList extends ColorPaletteState{}

class ColorPaletteAdded extends ColorPaletteState{}

class ColorPaletteEdited extends ColorPaletteState{}

class ColorPaletteDeleted extends ColorPaletteState{}

class ColorPaletteErrorState extends ColorPaletteState{
  final String message;

  ColorPaletteErrorState({required this.message});
}
