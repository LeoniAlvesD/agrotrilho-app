import 'package:flutter/material.dart';
import 'screens/lista_animais.dart';

void main() {
  runApp(AgrotrilhoApp());
}

class AgrotrilhoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrotrilho',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ListaAnimais(),
    );
  }
}