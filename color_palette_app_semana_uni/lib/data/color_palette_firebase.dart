import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_palette_app_semana_uni/models/color_palette_model.dart';
import 'package:firebase_core/firebase_core.dart';

class ColorPaletteFirebase {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addColorPalette(Map<String, dynamic> colorPalette) async{
    await _firebaseFirestore.collection('color_palettes').add(colorPalette);
  }

  Future<void> editColorPalette(String id, Map<String, dynamic> newData) async{
    await _firebaseFirestore.doc('color_palettes/$id').update(newData);
  }

  Future<List<ColorPalette>> getColorPalettes() async{
    QuerySnapshot snapshot = 
      await _firebaseFirestore.collection('color_palettes').get();

    List<ColorPalette> colorPalettes = [];

    snapshot.docs.forEach((element) { 
      colorPalettes.add(
        ColorPalette.fromJson(element.id, element.data() as Map<String, dynamic>)
      );
    });

    return colorPalettes;
  }
}