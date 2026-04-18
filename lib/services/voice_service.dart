import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Wraps [SpeechToText] with a web-safe fallback.
/// On platforms where speech recognition is unavailable, all operations
/// degrade gracefully without throwing.
class VoiceService extends ChangeNotifier {
  final SpeechToText _speech = SpeechToText();

  bool _isAvailable = false;
  bool _isListening = false;
  String _lastWords = '';
  String _statusMessage = '';

  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;
  String get lastWords => _lastWords;
  String get statusMessage => _statusMessage;

  /// Initialise the speech engine. Safe to call multiple times.
  Future<void> init() async {
    try {
      _isAvailable = await _speech.initialize(
        onError: (error) {
          _statusMessage = 'Erro: ${error.errorMsg}';
          _isListening = false;
          notifyListeners();
        },
        onStatus: (status) {
          _isListening = status == 'listening';
          notifyListeners();
        },
      );
    } catch (_) {
      _isAvailable = false;
    }
    notifyListeners();
  }

  /// Start listening; returns immediately if unavailable.
  Future<void> startListening({
    required void Function(String command) onCommand,
  }) async {
    if (!_isAvailable) {
      _statusMessage = 'Microfone não disponível neste dispositivo.';
      notifyListeners();
      return;
    }
    _lastWords = '';
    _statusMessage = 'Ouvindo…';
    notifyListeners();

    await _speech.listen(
      onResult: (result) {
        _lastWords = result.recognizedWords;
        notifyListeners();
        if (result.finalResult && _lastWords.isNotEmpty) {
          onCommand(_lastWords.toLowerCase().trim());
        }
      },
      listenFor: const Duration(seconds: 15),
      pauseFor: const Duration(seconds: 3),
      localeId: 'pt_BR',
    );
  }

  /// Stop listening.
  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
    _statusMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
}

/// Maps a recognised phrase to a route name.
String? commandToRoute(String command) {
  if (command.contains('novo lote') || command.contains('criar lote')) {
    return '/lotes';
  }
  if (command.contains('ver lote') || command.contains('lotes')) {
    return '/lotes';
  }
  if (command.contains('valorizar') || command.contains('ações') ||
      command.contains('acoes')) {
    return '/acoes';
  }
  if (command.contains('cadastrar animal') ||
      command.contains('novo animal') ||
      command.contains('animal')) {
    return '/animais';
  }
  if (command.contains('rastreabilidade') || command.contains('rastrear')) {
    return '/voz';
  }
  if (command.contains('sisbov') || command.contains('relatório') ||
      command.contains('relatorio')) {
    return '/relatorios';
  }
  return null;
}
