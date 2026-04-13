import 'package:flutter/material.dart';
import '../models/animal.dart';

class CadastroAnimal extends StatefulWidget {
  @override
  _CadastroAnimalState createState() => _CadastroAnimalState();
}

class _CadastroAnimalState extends State<CadastroAnimal> {
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final pesoController = TextEditingController();

  void salvar() {
    final animal = Animal(
      nome: nomeController.text,
      idade: int.tryParse(idadeController.text) ?? 0,
      peso: double.tryParse(pesoController.text) ?? 0.0,
    );

    Navigator.pop(context, animal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar Animal")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: idadeController,
              decoration: InputDecoration(labelText: "Idade"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: pesoController,
              decoration: InputDecoration(labelText: "Peso"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvar,
              child: Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}