class ColorPalette {
  late String title;
  late String id;
  late List<int> colors;

  ColorPalette({required this.title, required this.id, required this.colors});

  ColorPalette.fromJson(String id, Map<String, dynamic> json){
    this.id = id;
    title = json['title'];
    colors = json['colors'].cast<int>();
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['colors'] = this.colors;

    return data;
  }
}