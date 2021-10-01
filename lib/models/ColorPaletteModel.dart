class ColorPalette {
  late String title;
  late String id;
  late List<int> colors;

  ColorPalette({
    required this.id,
    required this.title,
    required this.colors,
  });

  ColorPalette.fromJson({
    required this.id,
    required Map<String, dynamic> json,
  }) {
    this.title = json['title'];
    this.colors = json['colors'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map();

    json['title'] = this.title;
    json['colors'] = this.colors;

    return json;
  }
}
