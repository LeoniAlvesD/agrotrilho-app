import 'package:flutter_test/flutter_test.dart';
import 'package:agrotrilho_app/models/animal.dart';
import 'package:agrotrilho_app/services/animal_service.dart';
import 'package:agrotrilho_app/services/qrcode_service.dart';
import 'package:agrotrilho_app/utils/validators.dart';

void main() {
  group('Animal Model', () {
    test('should create animal with required fields', () {
      final animal = Animal(nome: 'Mimosa', idade: 24, peso: 350.5);

      expect(animal.nome, 'Mimosa');
      expect(animal.idade, 24);
      expect(animal.peso, 350.5);
      expect(animal.observacoes, '');
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
      );

      expect(animal.id, 'test-id-123');
      expect(animal.observacoes, 'Animal saudável');
    });

    test('toMap should return correct map', () {
      final animal = Animal(
        id: 'map-id',
        nome: 'Bonita',
        idade: 12,
        peso: 280.0,
        observacoes: 'Boa saúde',
      );

      final map = animal.toMap();

      expect(map['id'], 'map-id');
      expect(map['nome'], 'Bonita');
      expect(map['idade'], 12);
      expect(map['peso'], 280.0);
      expect(map['observacoes'], 'Boa saúde');
    });

    test('fromMap should create correct animal', () {
      final map = {
        'id': 'from-map-id',
        'nome': 'Pintada',
        'idade': 18,
        'peso': 310.0,
        'observacoes': 'Observação teste',
      };

      final animal = Animal.fromMap(map);

      expect(animal.id, 'from-map-id');
      expect(animal.nome, 'Pintada');
      expect(animal.idade, 18);
      expect(animal.peso, 310.0);
      expect(animal.observacoes, 'Observação teste');
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
    });
  });

  group('AnimalService', () {
    test('should start with 3 example animals', () {
      final service = AnimalService();
      expect(service.animais.length, 3);
    });

    test('should add an animal', () {
      final service = AnimalService();
      final animal = Animal(nome: 'Nova', idade: 12, peso: 200);
      service.adicionar(animal);
      expect(service.animais.length, 4);
    });

    test('should remove an animal', () {
      final service = AnimalService();
      final id = service.animais.first.id;
      service.remover(id);
      expect(service.animais.length, 2);
      expect(service.buscarPorId(id), isNull);
    });

    test('should update an animal', () {
      final service = AnimalService();
      final original = service.animais.first;
      final atualizado = Animal(
        id: original.id,
        nome: 'Atualizada',
        idade: 99,
        peso: 999,
      );
      service.atualizar(atualizado);
      expect(service.buscarPorId(original.id)!.nome, 'Atualizada');
    });

    test('should search animals by name', () {
      final service = AnimalService();
      final resultados = service.buscar('mimosa');
      expect(resultados.length, 1);
      expect(resultados.first.nome, 'Mimosa');
    });

    test('should return all animals for empty query', () {
      final service = AnimalService();
      expect(service.buscar('').length, 3);
    });

    test('should find animal by id', () {
      final service = AnimalService();
      final id = service.animais.first.id;
      expect(service.buscarPorId(id), isNotNull);
    });

    test('should return null for unknown id', () {
      final service = AnimalService();
      expect(service.buscarPorId('unknown-id'), isNull);
    });
  });

  group('QrCodeService', () {
    test('should generate data from animal id', () {
      expect(QrCodeService.gerarDados('abc-123'), 'abc-123');
    });

    test('should validate UUID format', () {
      expect(
        QrCodeService.validarQrCode(
            '550e8400-e29b-41d4-a716-446655440000'),
        isTrue,
      );
    });

    test('should reject invalid QR code', () {
      expect(QrCodeService.validarQrCode('not-a-uuid'), isFalse);
      expect(QrCodeService.validarQrCode(null), isFalse);
      expect(QrCodeService.validarQrCode(''), isFalse);
    });
  });

  group('Validators', () {
    test('should validate nome', () {
      expect(Validators.validarNome(null), isNotNull);
      expect(Validators.validarNome(''), isNotNull);
      expect(Validators.validarNome('A'), isNotNull);
      expect(Validators.validarNome('Mimosa'), isNull);
    });

    test('should validate idade', () {
      expect(Validators.validarIdade(null), isNotNull);
      expect(Validators.validarIdade(''), isNotNull);
      expect(Validators.validarIdade('0'), isNotNull);
      expect(Validators.validarIdade('-1'), isNotNull);
      expect(Validators.validarIdade('abc'), isNotNull);
      expect(Validators.validarIdade('12'), isNull);
    });

    test('should validate peso', () {
      expect(Validators.validarPeso(null), isNotNull);
      expect(Validators.validarPeso(''), isNotNull);
      expect(Validators.validarPeso('0'), isNotNull);
      expect(Validators.validarPeso('-5'), isNotNull);
      expect(Validators.validarPeso('abc'), isNotNull);
      expect(Validators.validarPeso('350.5'), isNull);
    });
  });
}
