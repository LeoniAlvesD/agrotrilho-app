import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// A widget that lets users simulate a QR code scan on web.
///
/// Provides a text field where the user can enter an animal ID (or any value)
/// and a button to "submit" the simulated scan.
class WebQrSimulator extends StatefulWidget {
  /// Called when the user submits a simulated scan value.
  final ValueChanged<String> onSimulatedScan;

  const WebQrSimulator({super.key, required this.onSimulatedScan});

  @override
  State<WebQrSimulator> createState() => _WebQrSimulatorState();
}

class _WebQrSimulatorState extends State<WebQrSimulator> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) {
      widget.onSimulatedScan(value);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: colorScheme.tertiary),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Simulador QR Code (Web)',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'No modo web a câmera não está disponível. '
              'Use o campo abaixo para simular a leitura de um QR Code.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'ID do Animal ou dados JSON',
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  tooltip: 'Simular leitura',
                  onPressed: _submit,
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
            SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Simular QR Code lido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
