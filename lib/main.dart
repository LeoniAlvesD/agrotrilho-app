import 'package:flutter/material.dart';
import 'screens/lista_animais.dart';

void main() {
  runApp(const AgrotrilhoApp());
}

class AgrotrilhoApp extends StatelessWidget {
  const AgrotrilhoApp({super.key});

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