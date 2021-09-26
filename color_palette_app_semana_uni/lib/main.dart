import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ColorPaletteApp());
}

class ColorPaletteApp extends StatefulWidget {
  const ColorPaletteApp({ Key? key }) : super(key: key);

  @override
  _ColorPaletteAppState createState() => _ColorPaletteAppState();
}

class _ColorPaletteAppState extends State<ColorPaletteApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white, accentColor: Colors.black),
    );
  }
}

