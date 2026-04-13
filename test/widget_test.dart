import 'package:flutter_test/flutter_test.dart';

import 'package:agrotrilho_app/main.dart';
import 'package:agrotrilho_app/models/animal.dart';
import 'package:agrotrilho_app/services/animal_service.dart';
import 'package:agrotrilho_app/services/qrcode_service.dart';

void main() {
  group('Animal Model', () {
    test('cria animal com ID automático', () {
      final animal = Animal.criar(nome: 'Teste', idade: 12, peso: 300.0);
      expect(animal.id, isNotEmpty);
      expect(animal.nome, 'Teste');
      expect(animal.idade, 12);
      expect(animal.peso, 300.0);
      expect(animal.status, 'Ativo');
      expect(animal.qrCodeData, 'agrotrilho://animal/${animal.id}');
    });

    test('formata idade corretamente', () {
      expect(Animal(nome: 'A', idade: 6, peso: 100).idadeFormatada, '6 meses');
      expect(Animal(nome: 'A', idade: 1, peso: 100).idadeFormatada, '1 mês');
      expect(Animal(nome: 'A', idade: 12, peso: 100).idadeFormatada, '1 ano');
      expect(Animal(nome: 'A', idade: 24, peso: 100).idadeFormatada, '2 anos');
      expect(
        Animal(nome: 'A', idade: 14, peso: 100).idadeFormatada,
        '1 ano e 2 meses',
      );
    });

    test('formata peso corretamente', () {
      expect(Animal(nome: 'A', idade: 12, peso: 450.5).pesoFormatado, '450.5 kg');
    });

    test('copyWith mantém campos não alterados', () {
      final original = Animal(nome: 'Original', idade: 12, peso: 300.0);
      final copia = original.copyWith(nome: 'Modificado');
      expect(copia.nome, 'Modificado');
      expect(copia.id, original.id);
      expect(copia.idade, 12);
      expect(copia.peso, 300.0);
    });

    test('toMap e fromMap preservam dados', () {
      final animal = Animal(
        nome: 'Teste Map',
        idade: 24,
        peso: 400.0,
        observacoes: 'Obs teste',
      );
      final map = animal.toMap();
      final restaurado = Animal.fromMap(map);
      expect(restaurado.nome, animal.nome);
      expect(restaurado.idade, animal.idade);
      expect(restaurado.peso, animal.peso);
      expect(restaurado.observacoes, animal.observacoes);
    });
  });

  group('AnimalService', () {
    test('inicializa com 3 animais de exemplo', () {
      final service = AnimalService();
      expect(service.total, 3);
    });

    test('adiciona animal', () {
      final service = AnimalService();
      service.adicionar(Animal(nome: 'Novo', idade: 6, peso: 150.0));
      expect(service.total, 4);
    });

    test('remove animal por ID', () {
      final service = AnimalService();
      final id = service.animais.first.id;
      service.remover(id);
      expect(service.total, 2);
      expect(service.buscarPorId(id), isNull);
    });

    test('busca por nome (filtro)', () {
      final service = AnimalService();
      final resultado = service.filtrarPorNome('Bessie');
      expect(resultado.length, 1);
      expect(resultado.first.nome, 'Bessie');
    });

    test('filtro vazio retorna todos', () {
      final service = AnimalService();
      expect(service.filtrarPorNome('').length, 3);
    });

    test('atualiza animal existente', () {
      final service = AnimalService();
      final animal = service.animais.first;
      final atualizado = animal.copyWith(nome: 'Atualizado');
      service.atualizar(atualizado);
      expect(service.buscarPorId(animal.id)?.nome, 'Atualizado');
    });
  });

  group('QRCodeService', () {
    test('gera QR Code com formato correto', () {
      final data = QRCodeService.gerarQRCodeData('abc123');
      expect(data, 'agrotrilho://animal/abc123');
    });

    test('valida QR Code do Agrotrilho', () {
      expect(QRCodeService.validarQRCode('agrotrilho://animal/abc'), isTrue);
      expect(QRCodeService.validarQRCode('outroapp://animal/abc'), isFalse);
    });

    test('extrai ID do QR Code', () {
      expect(
        QRCodeService.extrairAnimalId('agrotrilho://animal/abc123'),
        'abc123',
      );
      expect(QRCodeService.extrairAnimalId('invalido'), isNull);
      expect(QRCodeService.extrairAnimalId('agrotrilho://animal/'), isNull);
    });
  });

  testWidgets('AgrotrilhoApp renderiza corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const AgrotrilhoApp());
    await tester.pumpAndSettle();

    // Verifica que o título do app aparece
    expect(find.text('Agrotrilho 🐄'), findsOneWidget);

    // Verifica que os animais de exemplo são exibidos
    expect(find.text('Bessie'), findsOneWidget);
    expect(find.text('Touro Rex'), findsOneWidget);
    expect(find.text('Mimi'), findsOneWidget);
  });
}
