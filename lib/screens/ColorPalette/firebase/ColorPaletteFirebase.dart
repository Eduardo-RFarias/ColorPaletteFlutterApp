import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_pallete_app/models/ColorPaletteModel.dart';

class ColorPaletteFirebase {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addColorPalette({
    required Map<String, dynamic> json,
  }) async {
    await _firebaseFirestore.collection('color_palettes').add(json);
  }

  Future<List<ColorPalette>> retrieveColorPalettes() async {
    final QuerySnapshot snapshot =
        await _firebaseFirestore.collection('color_palettes').get();

    final List<ColorPalette> colorPalettes = [];

    snapshot.docs.forEach((element) {
      colorPalettes.add(ColorPalette.fromJson(
        id: element.id,
        json: element.data() as Map<String, dynamic>,
      ));
    });

    return colorPalettes;
  }

  Future<void> updateColorPalette({
    required String id,
    required Map<String, dynamic> json,
  }) async {
    await _firebaseFirestore.collection('color_palettes').doc(id).update(json);
  }

  Future<void> deleteColorPalette({
    required String id,
  }) async {
    await _firebaseFirestore.collection('color_palettes').doc(id).delete();
  }
}
