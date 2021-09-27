abstract class ColorFormEvents {
  const  ColorFormEvents();
}

class ChangeColorFormEvents extends ColorFormEvents{
  final String id;
  final String title;
  final List<int> colors;
  final int index;

  const ChangeColorFormEvents({
    required this.id,
    required this.title,
    required this.colors,
    required this.index});
}

class RandomizeColorFormEvents  extends ColorFormEvents{
  final String id;
  final String title;

  const RandomizeColorFormEvents(
    {required this.id, required this.title}
  );
}