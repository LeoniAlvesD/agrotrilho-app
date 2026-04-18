import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/voice_service.dart';
import '../../utils/constants.dart';
import '../../widgets/voice_command_help.dart';

/// Voice-tracking screen: lets the user start/stop listening and shows
/// the recognised text as large readable feedback.
class VozScreen extends StatefulWidget {
  const VozScreen({super.key});

  @override
  State<VozScreen> createState() => _VozScreenState();
}

class _VozScreenState extends State<VozScreen> {
  late final VoiceService _voice;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    _voice = context.read<VoiceService>();
    _voice.init().then((_) {
      if (mounted) setState(() => _initialised = true);
    });
  }

  void _toggle() {
    if (_voice.isListening) {
      _voice.stopListening();
    } else {
      _voice.startListening(
        onCommand: (cmd) => _handleCommand(cmd),
      );
    }
  }

  void _handleCommand(String command) {
    final route = commandToRoute(command);
    if (route != null && mounted) {
      // Navigate using named routes when available; otherwise show feedback.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comando reconhecido: "$command"'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _voice,
      builder: (context, _) {
        final isListening = _voice.isListening;
        final isAvailable = _voice.isAvailable;
        final lastWords = _voice.lastWords;
        final status = _voice.statusMessage;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // ── Mic visualiser ───────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isListening
                      ? colorScheme.primary.withAlpha(30)
                      : const Color(0xFF0288D1).withAlpha(20),
                  border: Border.all(
                    color: isListening
                        ? colorScheme.primary
                        : const Color(0xFF0288D1).withAlpha(100),
                    width: 3,
                  ),
                  boxShadow: isListening
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withAlpha(60),
                            blurRadius: 30,
                            spreadRadius: 6,
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  isListening ? Icons.mic : Icons.mic_none,
                  size: 64,
                  color: isListening
                      ? colorScheme.primary
                      : const Color(0xFF0288D1),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Status text ──────────────────────────────────────────
              if (isListening)
                Text(
                  'Ouvindo…',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                )
              else
                Text(
                  'Rastreamento por Voz',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                isAvailable
                    ? 'Fale um comando após pressionar o botão'
                    : 'Microfone não disponível neste dispositivo',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Recognised words ─────────────────────────────────────
              if (lastWords.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: colorScheme.primary.withAlpha(60)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Você disse:',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"$lastWords"',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),

              if (status.isNotEmpty && lastWords.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    status,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.orange[800],
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Main action button ────────────────────────────────────
              if (!_initialised)
                const CircularProgressIndicator()
              else if (!isAvailable)
                _UnavailableMessage()
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _toggle,
                    icon: Icon(isListening ? Icons.stop : Icons.mic, size: 26),
                    label: Text(
                      isListening ? 'Parar' : 'Começar a Ouvir',
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: isListening
                          ? Colors.red[600]
                          : colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Voice command help ────────────────────────────────────
              const VoiceCommandHelp(),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }
}

class _UnavailableMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.orange.withAlpha(80)),
      ),
      child: Column(
        children: [
          const Icon(Icons.mic_off, size: 40, color: Colors.orange),
          const SizedBox(height: 12),
          Text(
            'Microfone não disponível',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.orange[800],
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Verifique as permissões do navegador ou use um dispositivo com microfone.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.orange[700],
            ),
          ),
        ],
      ),
    );
  }
}
