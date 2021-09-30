import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_palette_app_semana_uni/models/color_palette_model.dart';
import 'package:firebase_core/firebase_core.dart';

// Classe que faz a comunicacao com o firebase.
class ColorPaletteFirebase {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Adiciona a paleta, em formato de json, para a collection color_palettes.
  Future<void> addColorPalette(Map<String, dynamic> colorPalette) async{
    await _firebaseFirestore.collection('color_palettes').add(colorPalette);
  }

  // Edita a paletta identificada pelo id enviado
  Future<void> editColorPalette(String id, Map<String, dynamic> newData) async{
    await _firebaseFirestore.doc('color_palettes/$id').update(newData);
  }

  // Remove uma paleta da collection color_palettes
   Future<void> removeColorPalette(String id) async{
    await _firebaseFirestore.doc('color_palettes/$id').delete();
  }

  // Pega todas as paletas armazenadas na collection color_palettes.
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