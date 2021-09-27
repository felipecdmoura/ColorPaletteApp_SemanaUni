import 'package:color_palette_app_semana_uni/models/color_palette_model.dart';

class ColorFormState {
  String id;
  String title;
  late List<int> colors;

  ColorFormState(
    {required this.id, required this.title, required this.colors}
  );
}