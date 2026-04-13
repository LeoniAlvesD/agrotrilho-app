import 'package:flutter/material.dart';
import '../models/animal.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;

  AnimalCard({required this.animal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text(animal.nome),
        subtitle: Text("Peso: ${animal.peso} kg | Idade: ${animal.idade}"),
        leading: Icon(Icons.pets, color: Colors.green),
      ),
    );
  }
}