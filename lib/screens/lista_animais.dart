import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../widgets/animal_card.dart';
import 'cadastro_animal.dart';

class ListaAnimais extends StatefulWidget {
  @override
  _ListaAnimaisState createState() => _ListaAnimaisState();
}

class _ListaAnimaisState extends State<ListaAnimais> {
  List<Animal> animais = [];

  void adicionarAnimal(Animal animal) {
    setState(() {
      animais.add(animal);
    });
  }

  void abrirCadastro() async {
    final novoAnimal = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CadastroAnimal()),
    );

    if (novoAnimal != null) {
      adicionarAnimal(novoAnimal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agrotrilho 🚜"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCadastro,
        child: Icon(Icons.add),
      ),
      body: animais.isEmpty
          ? Center(child: Text("Nenhum animal cadastrado"))
          : ListView.builder(
              itemCount: animais.length,
              itemBuilder: (context, index) {
                return AnimalCard(animal: animais[index]);
              },
            ),
    );
  }
}