import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:agrotrilho_app/models/animal.dart';
import 'package:agrotrilho_app/models/platform_config.dart';
import 'package:agrotrilho_app/services/qrcode_service.dart';
import 'package:agrotrilho_app/services/nfc_platform_service.dart';
import 'package:agrotrilho_app/utils/validators.dart';
import 'package:agrotrilho_app/utils/constants.dart';
import 'package:agrotrilho_app/utils/responsive_helper.dart';
import 'package:agrotrilho_app/utils/platform_helper.dart';
import 'package:agrotrilho_app/utils/platform_config.dart';

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
      final map = {'id': 'min-id', 'nome': 'Malhada', 'idade': 6, 'peso': 150};

      final animal = Animal.fromMap(map);

      expect(animal.observacoes, '');
    });

    test('toJson/fromJson should round-trip correctly', () {
      final original = Animal(
        id: 'json-id',
        nome: 'Estrela',
        idade: 36,
        peso: 420.0,
        observacoes: 'Vacinação em dia',
      );

      final jsonMap = original.toJson();
      final restored = Animal.fromJson(jsonMap);

      expect(restored.id, original.id);
      expect(restored.nome, original.nome);
      expect(restored.idade, original.idade);
      expect(restored.peso, original.peso);
      expect(restored.observacoes, original.observacoes);
    });

    test('encodeList/decodeList should round-trip list', () {
      final animals = [
        Animal(id: 'a1', nome: 'Mimosa', idade: 24, peso: 350.5),
        Animal(
          id: 'a2',
          nome: 'Trovão',
          idade: 18,
          peso: 280.0,
          observacoes: 'Novilho',
        ),
      ];

      final encoded = Animal.encodeList(animals);
      expect(encoded, isA<String>());

      // Verify it's valid JSON
      final decoded = json.decode(encoded);
      expect(decoded, isA<List>());
      expect(decoded.length, 2);

      final restored = Animal.decodeList(encoded);
      expect(restored.length, 2);
      expect(restored[0].id, 'a1');
      expect(restored[0].nome, 'Mimosa');
      expect(restored[1].id, 'a2');
      expect(restored[1].observacoes, 'Novilho');
    });
  });

  group('QrCodeService', () {
    test('should generate JSON data from animal', () {
      final animal = Animal(
        id: 'abc-123',
        nome: 'Mimosa',
        idade: 24,
        peso: 350.5,
        observacoes: 'Boa produção',
      );
      final result = QrCodeService.gerarDados(animal);
      final data = json.decode(result) as Map<String, dynamic>;

      expect(data['id'], 'abc-123');
      expect(data['nome'], 'Mimosa');
      expect(data['idade'], 24);
      expect(data['peso'], 350.5);
      expect(data['observacoes'], 'Boa produção');
    });

    test('should validate JSON QR code format', () {
      final jsonQr = json.encode({
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'nome': 'Mimosa',
      });
      expect(QrCodeService.validarQrCode(jsonQr), isTrue);
    });

    test('should validate legacy UUID format', () {
      expect(
        QrCodeService.validarQrCode('550e8400-e29b-41d4-a716-446655440000'),
        isTrue,
      );
    });

    test('should reject invalid QR code', () {
      expect(QrCodeService.validarQrCode('not-a-uuid'), isFalse);
      expect(QrCodeService.validarQrCode(null), isFalse);
      expect(QrCodeService.validarQrCode(''), isFalse);
    });

    test('should extract id from JSON QR code', () {
      final jsonQr = json.encode({'id': 'test-id-123', 'nome': 'Mimosa'});
      expect(QrCodeService.extrairId(jsonQr), 'test-id-123');
    });

    test('should extract id from legacy UUID QR code', () {
      expect(
        QrCodeService.extrairId('550e8400-e29b-41d4-a716-446655440000'),
        '550e8400-e29b-41d4-a716-446655440000',
      );
    });

    test('should return null for invalid QR code', () {
      expect(QrCodeService.extrairId(null), isNull);
      expect(QrCodeService.extrairId(''), isNull);
      expect(QrCodeService.extrairId('not-valid'), isNull);
    });
  });

  group('Validators', () {
    test('should validate nome', () {
      expect(Validators.validarNome(null), isNotNull);
      expect(Validators.validarNome(''), isNotNull);
      expect(Validators.validarNome('A'), isNotNull);
      expect(Validators.validarNome('Mimosa'), isNull);
    });

    test('should reject nome exceeding max length', () {
      final longName = 'A' * (Validators.maxNomeLength + 1);
      final result = Validators.validarNome(longName);
      expect(result, isNotNull);
      expect(result, contains('máximo'));
    });

    test('should validate idade', () {
      expect(Validators.validarIdade(null), isNotNull);
      expect(Validators.validarIdade(''), isNotNull);
      expect(Validators.validarIdade('0'), isNotNull);
      expect(Validators.validarIdade('-1'), isNotNull);
      expect(Validators.validarIdade('abc'), isNotNull);
      expect(Validators.validarIdade('12'), isNull);
    });

    test('should reject idade exceeding max', () {
      expect(Validators.validarIdade('${Validators.maxIdade + 1}'), isNotNull);
    });

    test('should accept idade at max boundary', () {
      expect(Validators.validarIdade('${Validators.maxIdade}'), isNull);
    });

    test('should validate peso', () {
      expect(Validators.validarPeso(null), isNotNull);
      expect(Validators.validarPeso(''), isNotNull);
      expect(Validators.validarPeso('0'), isNotNull);
      expect(Validators.validarPeso('-5'), isNotNull);
      expect(Validators.validarPeso('abc'), isNotNull);
      expect(Validators.validarPeso('350.5'), isNull);
    });

    test('should reject peso exceeding max', () {
      expect(Validators.validarPeso('${Validators.maxPeso + 1}'), isNotNull);
    });

    test('should accept peso at max boundary', () {
      expect(Validators.validarPeso('${Validators.maxPeso}'), isNull);
    });

    test('should trim whitespace before parsing', () {
      expect(Validators.validarIdade('  12  '), isNull);
      expect(Validators.validarPeso('  350.5  '), isNull);
      expect(Validators.validarNome('  Mimosa  '), isNull);
    });
  });

  group('ResponsiveHelper', () {
    test('breakpoints should be correctly defined', () {
      expect(ResponsiveHelper.mobileBreakpoint, 600);
      expect(ResponsiveHelper.tabletBreakpoint, 1200);
    });
  });

  group('AppConstants', () {
    test('AppColors should have primary color', () {
      expect(AppColors.primary.value, 0xFF2E7D32);
    });

    test('AppColors should have info color', () {
      expect(AppColors.info.value, 0xFF1976D2);
    });

    test('AppStrings should have app name', () {
      expect(AppStrings.appName, 'Agrotrilho');
      expect(AppStrings.appVersion, isNotEmpty);
    });

    test('AppStrings should have dashboard strings', () {
      expect(AppStrings.greeting, isNotEmpty);
      expect(AppStrings.dashboardSubtitle, isNotEmpty);
      expect(AppStrings.totalAnimais, isNotEmpty);
      expect(AppStrings.cadastrarAnimal, isNotEmpty);
    });

    test('AppStrings should have empty state strings', () {
      expect(AppStrings.nenhumAnimal, isNotEmpty);
      expect(AppStrings.nenhumDado, isNotEmpty);
      expect(AppStrings.cadastreAnimais, isNotEmpty);
    });

    test('AppStrings should have relatórios strings', () {
      expect(AppStrings.relatoriosTitulo, isNotEmpty);
      expect(AppStrings.resumoGeral, isNotEmpty);
      expect(AppStrings.distribuicaoPeso, isNotEmpty);
      expect(AppStrings.distribuicaoIdade, isNotEmpty);
    });

    test('AppSpacing should have consistent values', () {
      expect(AppSpacing.xs, 4);
      expect(AppSpacing.sm, 8);
      expect(AppSpacing.md, 12);
      expect(AppSpacing.lg, 16);
      expect(AppSpacing.xl, 20);
      expect(AppSpacing.xxl, 24);
      expect(AppSpacing.xxxl, 32);
    });
  });

  group('PlatformHelper', () {
    // Tests run in the Dart VM (not web, not Android, not iOS), so:
    test('isWeb should be false in test environment', () {
      expect(PlatformHelper.isWeb, isFalse);
    });

    test('isMobile should equal isAndroid || isIOS', () {
      expect(PlatformHelper.isMobile,
          PlatformHelper.isAndroid || PlatformHelper.isIOS);
    });

    test('platformName should return a non-empty string', () {
      expect(PlatformHelper.platformName, isNotEmpty);
    });

    test('supportsQrScanning should always be true', () {
      expect(PlatformHelper.supportsQrScanning, isTrue);
    });

    test('supportsNfc should equal isMobile', () {
      expect(PlatformHelper.supportsNfc, PlatformHelper.isMobile);
    });

    test('supportsCameraScanning should equal isMobile', () {
      expect(PlatformHelper.supportsCameraScanning, PlatformHelper.isMobile);
    });
  });

  group('PlatformConfig (utils)', () {
    test('modeLabel should return a non-empty string', () {
      expect(PlatformConfig.modeLabel, isNotEmpty);
    });

    test('scannerCapabilities should return a non-empty string', () {
      expect(PlatformConfig.scannerCapabilities, isNotEmpty);
    });

    test('shouldSimulateQr should match isWeb', () {
      expect(PlatformConfig.shouldSimulateQr, PlatformHelper.isWeb);
    });
  });

  group('PlatformCapabilities model', () {
    test('web constructor should disable NFC and camera', () {
      const caps = PlatformCapabilities.web();
      expect(caps.supportsNfc, isFalse);
      expect(caps.supportsCameraScanning, isFalse);
      expect(caps.supportsQrScanning, isTrue);
      expect(caps.platformName, 'Web');
    });

    test('android constructor should enable NFC and camera', () {
      const caps = PlatformCapabilities.android();
      expect(caps.supportsNfc, isTrue);
      expect(caps.supportsCameraScanning, isTrue);
      expect(caps.supportsQrScanning, isTrue);
      expect(caps.platformName, 'Android');
    });

    test('ios constructor should enable NFC and camera', () {
      const caps = PlatformCapabilities.ios();
      expect(caps.supportsNfc, isTrue);
      expect(caps.supportsCameraScanning, isTrue);
      expect(caps.supportsQrScanning, isTrue);
      expect(caps.platformName, 'iOS');
    });
  });

  group('NfcPlatformService', () {
    test('statusText should return a non-empty string', () {
      final service = NfcPlatformService();
      expect(service.statusText, isNotEmpty);
    });

    test('isAvailable should return a future', () async {
      final service = NfcPlatformService();
      final result = await service.isAvailable();
      expect(result, isA<bool>());
    });
  });
}
