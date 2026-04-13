import 'package:flutter/material.dart';
import '../../services/nfc_platform_service.dart';
import '../../utils/platform_helper.dart';
import '../../utils/constants.dart';

/// Screen for reading NFC tags.
///
/// On **web** (and desktop) a friendly message explains that NFC is not
/// available.  On **mobile** the screen shows a reader UI that can be
/// connected to a real NFC session via [NfcPlatformService].
class NfcReaderScreen extends StatefulWidget {
  const NfcReaderScreen({super.key});

  @override
  State<NfcReaderScreen> createState() => _NfcReaderScreenState();
}

class _NfcReaderScreenState extends State<NfcReaderScreen> {
  final NfcPlatformService _nfcService = NfcPlatformService();
  bool _isReading = false;
  String? _lastTagId;
  String? _error;

  @override
  void dispose() {
    if (_isReading) _nfcService.stopReading();
    super.dispose();
  }

  void _toggleReading() {
    if (_isReading) {
      _nfcService.stopReading();
      setState(() => _isReading = false);
    } else {
      setState(() {
        _isReading = true;
        _error = null;
      });
      _nfcService.startReading(
        onTagRead: (tagId) {
          setState(() {
            _lastTagId = tagId;
            _isReading = false;
          });
        },
        onError: (error) {
          setState(() {
            _error = error;
            _isReading = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Leitor NFC')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: PlatformHelper.supportsNfc
                ? _buildMobileBody(theme, colorScheme)
                : _buildWebBody(theme, colorScheme),
          ),
        ),
      ),
    );
  }

  // ── Web / unsupported platform ─────────────────────────────

  Widget _buildWebBody(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.nfc,
          size: 100,
          color: colorScheme.onSurfaceVariant.withAlpha(80),
          semanticLabel: 'NFC indisponível',
        ),
        SizedBox(height: AppSpacing.xl),
        Text(
          'NFC não disponível',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          _nfcService.statusText,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant.withAlpha(180),
          ),
        ),
        SizedBox(height: AppSpacing.xxl),
        Card(
          color: colorScheme.errorContainer,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.onErrorContainer),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Para usar NFC, abra o app em um dispositivo Android ou iOS.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Mobile (Android / iOS) ─────────────────────────────────

  Widget _buildMobileBody(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _isReading
              ? _buildReadingIndicator(colorScheme)
              : Icon(
                  Icons.nfc,
                  key: const ValueKey('idle'),
                  size: 100,
                  color: colorScheme.primary,
                  semanticLabel: 'Leitor NFC',
                ),
        ),
        SizedBox(height: AppSpacing.xl),
        Text(
          _isReading ? 'Aproxime a tag NFC…' : 'Leitor NFC',
          style: theme.textTheme.headlineSmall,
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          _isReading
              ? 'Mantenha o dispositivo próximo à tag.'
              : 'Toque no botão abaixo para iniciar a leitura.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.xxl),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _toggleReading,
            icon: Icon(_isReading ? Icons.stop : Icons.nfc),
            label: Text(_isReading ? 'Parar leitura' : 'Iniciar leitura NFC'),
          ),
        ),
        if (_lastTagId != null) ...[
          SizedBox(height: AppSpacing.xxl),
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: colorScheme.primary),
                      SizedBox(width: AppSpacing.sm),
                      Text('Tag lida com sucesso',
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const Divider(),
                  Text(
                    'ID: $_lastTagId',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (_error != null) ...[
          SizedBox(height: AppSpacing.lg),
          Card(
            color: colorScheme.errorContainer,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      _error!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReadingIndicator(ColorScheme colorScheme) {
    return SizedBox(
      key: const ValueKey('reading'),
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: colorScheme.primary,
            ),
          ),
          Icon(Icons.nfc, size: 48, color: colorScheme.primary),
        ],
      ),
    );
  }
}
