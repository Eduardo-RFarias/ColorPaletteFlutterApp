abstract class ColorFormEvent {
  ColorFormEvent();
}

class ChangeColorFormEvent extends ColorFormEvent {
  final String id;
  final int index;
  final String title;
  final List<int> colors;

  ChangeColorFormEvent({
    required this.id,
    required this.index,
    required this.title,
    required this.colors,
  });
}

class RandomizeColorFormEvent extends ColorFormEvent {
  final String id;
  final String title;

  RandomizeColorFormEvent({
    required this.id,
    required this.title,
  });
}
