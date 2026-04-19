import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

/// Help / "Como usar" screen.
class AjudaScreen extends StatelessWidget {
  const AjudaScreen({super.key});

  static const _steps = <_Step>[
    _Step(
      number: '1',
      title: 'Cadastre seus animais',
      description:
          'Toque em "Cadastrar Animal" na tela inicial e preencha os dados do animal.',
      icon: Icons.pets,
      color: Color(0xFF2E7D32),
    ),
    _Step(
      number: '2',
      title: 'Registre sua fazenda',
      description:
          'Adicione sua propriedade em "Cadastrar Fazenda" com nome, município e área.',
      icon: Icons.house_outlined,
      color: Color(0xFF6D4C41),
    ),
    _Step(
      number: '3',
      title: 'Use a Rastreabilidade',
      description:
          'Escaneie QR Codes ou leia brincos NFC para registrar movimentações.',
      icon: Icons.qr_code_scanner,
      color: Color(0xFF1565C0),
    ),
    _Step(
      number: '4',
      title: 'Gerencie seus lotes',
      description:
          'Agrupe animais em lotes por safra, fazenda ou destino de venda.',
      icon: Icons.layers,
      color: Color(0xFF6A1B9A),
    ),
    _Step(
      number: '5',
      title: 'Acompanhe métricas',
      description:
          'Na tela inicial veja SISBOV, valorização estimada e custo mensal do rebanho.',
      icon: Icons.bar_chart,
      color: Color(0xFFE65100),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = ResponsiveHelper.getPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Como usar o Sistema'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: padding.copyWith(top: 24, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.agriculture, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'AgroTrilho',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rastreabilidade animal por voz para pequenos e médios produtores rurais',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(210),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Passo a passo',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            ..._steps.map((s) => _StepCard(step: s)),

            const SizedBox(height: 28),

            // Contact / support card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.support_agent,
                        color: Color(0xFF2E7D32), size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Precisa de ajuda?',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Entre em contato: suporte@agrotrilho.com',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  const _Step({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _StepCard extends StatelessWidget {
  final _Step step;
  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(7),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: step.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                step.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(step.icon, color: step.color, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        step.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  step.description,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
