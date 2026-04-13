import 'package:flutter_test/flutter_test.dart';
import 'package:agrotrilho_app/models/animal.dart';

void main() {
  group('Animal Model', () {
    test('should create animal with required fields', () {
      final animal = Animal(nome: 'Mimosa', idade: 24, peso: 350.5);

      expect(animal.nome, 'Mimosa');
      expect(animal.idade, 24);
      expect(animal.peso, 350.5);
      expect(animal.observacoes, '');
      expect(animal.nfcTagId, isNull);
      expect(animal.id, isNotEmpty);
    });

    test('should generate unique ids', () {
      final a1 = Animal(nome: 'A', idade: 1, peso: 100);
      final a2 = Animal(nome: 'B', idade: 2, peso: 200);

      expect(a1.id, isNot(equals(a2.id)));
    });

    test('should create animal with all fields', () {
      final animal = Animal(
        id: 'test-id-123',
        nome: 'Estrela',
        idade: 36,
        peso: 420.0,
        observacoes: 'Animal saudável',
        nfcTagId: 'aa:bb:cc:dd',
      );

      expect(animal.id, 'test-id-123');
      expect(animal.observacoes, 'Animal saudável');
      expect(animal.nfcTagId, 'aa:bb:cc:dd');
    });

    test('toMap should return correct map', () {
      final animal = Animal(
        id: 'map-id',
        nome: 'Bonita',
        idade: 12,
        peso: 280.0,
        observacoes: 'Boa saúde',
        nfcTagId: '11:22:33',
      );

      final map = animal.toMap();

      expect(map['id'], 'map-id');
      expect(map['nome'], 'Bonita');
      expect(map['idade'], 12);
      expect(map['peso'], 280.0);
      expect(map['observacoes'], 'Boa saúde');
      expect(map['nfcTagId'], '11:22:33');
    });

    test('fromMap should create correct animal', () {
      final map = {
        'id': 'from-map-id',
        'nome': 'Pintada',
        'idade': 18,
        'peso': 310.0,
        'observacoes': 'Observação teste',
        'nfcTagId': 'ff:ee:dd',
      };

      final animal = Animal.fromMap(map);

      expect(animal.id, 'from-map-id');
      expect(animal.nome, 'Pintada');
      expect(animal.idade, 18);
      expect(animal.peso, 310.0);
      expect(animal.observacoes, 'Observação teste');
      expect(animal.nfcTagId, 'ff:ee:dd');
    });

    test('fromMap should handle missing optional fields', () {
      final map = {
        'id': 'min-id',
        'nome': 'Malhada',
        'idade': 6,
        'peso': 150,
      };

      final animal = Animal.fromMap(map);

      expect(animal.observacoes, '');
      expect(animal.nfcTagId, isNull);
    });

    test('nfcTagId should be mutable', () {
      final animal = Animal(nome: 'Teste', idade: 1, peso: 100);
      expect(animal.nfcTagId, isNull);

      animal.nfcTagId = 'aa:bb:cc';
      expect(animal.nfcTagId, 'aa:bb:cc');
    });
  });
}
