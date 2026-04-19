import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/animal_service.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/metric_card.dart';
import '../lotes/lotes_screen.dart';
import '../rastreabilidade/rastreabilidade_screen.dart';
import '../cadastro/cadastro_screen.dart';
import '../ajuda/ajuda_screen.dart';

/// Simplified Home screen — contains ALL navigation buttons, no drawer/bottom-nav.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Consumer<AnimalService>(
          builder: (context, service, _) {
            final animais = service.animais;
            final totalAnimais = animais.length;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(totalAnimais: totalAnimais),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ResponsiveHelper.getPadding(context).left,
                      right: ResponsiveHelper.getPadding(context).right,
                      top: 20,
                      bottom: 28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(context, 'Visão Geral'),
                        const SizedBox(height: 12),
                        _MetricsGrid(totalAnimais: totalAnimais),
                        const SizedBox(height: 28),
                        _sectionTitle(context, 'Acesso Rápido'),
                        const SizedBox(height: 12),
                        const _NavCards(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }
}

// ── Green gradient header ─────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final int totalAnimais;
  const _Header({required this.totalAnimais});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 28,
        isMobile ? 18 : 24,
        isMobile ? 16 : 28,
        isMobile ? 24 : 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo row + action buttons
          Row(
            children: [
              const Icon(Icons.agriculture, size: 36, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                AppStrings.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: isMobile ? 22 : 26,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              _HeaderButton(
                icon: Icons.mic,
                label: 'Microfone',
                onTap: () => _permitirMicrofone(context),
              ),
              const SizedBox(width: 8),
              _HeaderButton(
                icon: Icons.help_outline,
                label: 'Ajuda',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AjudaScreen()),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Main title
          Text(
            'Rastreabilidade Animal por voz',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: isMobile ? 20 : 24,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tecnologia inclusiva para pequenos e médios produtores rurais',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withAlpha(210),
              fontSize: isMobile ? 13 : 15,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // "Como usar" CTA
          Center(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AjudaScreen()),
              ),
              icon: const Icon(Icons.play_circle_outline,
                  color: Colors.white, size: 20),
              label: const Text(
                'Como usar o Sistema',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white70, width: 1.5),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _permitirMicrofone(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permissão de microfone solicitada'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HeaderButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(80), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Responsive metrics grid (2×2) ────────────────────────────────────────────

class _MetricsGrid extends StatelessWidget {
  final int totalAnimais;
  const _MetricsGrid({required this.totalAnimais});

  @override
  Widget build(BuildContext context) {
    final cols = ResponsiveHelper.isMobile(context) ? 2 : 4;
    final cards = [
      MetricCard(
        icon: Icons.pets,
        title: 'Total de Animais',
        value: '$totalAnimais',
        color: const Color(0xFF2E7D32),
      ),
      MetricCard(
        icon: Icons.verified_outlined,
        title: 'SISBOV Conforme',
        value: '92%',
        color: const Color(0xFF1565C0),
      ),
      MetricCard(
        icon: Icons.trending_up,
        title: 'Valorização',
        value: '+18%',
        color: const Color(0xFF6A1B9A),
      ),
      MetricCard(
        icon: Icons.attach_money,
        title: 'Custo Mensal',
        value: 'R\$2.1k',
        color: const Color(0xFFE65100),
      ),
    ];

    if (cols >= 4) {
      return Row(
        children: cards
            .map((c) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: c,
                  ),
                ))
            .toList(),
      );
    }

    // 2-column grid
    return Column(
      children: [
        Row(
          children: cards.take(2).map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: c,
                ),
              )).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          children: cards.skip(2).map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: c,
                ),
              )).toList(),
        ),
      ],
    );
  }
}

// ── Large navigation cards ────────────────────────────────────────────────────

class _NavCards extends StatelessWidget {
  const _NavCards();

  @override
  Widget build(BuildContext context) {
    final cols = ResponsiveHelper.isMobile(context) ? 1 : 2;

    final items = [
      _NavItem(
        icon: Icons.pets,
        label: 'Cadastrar Animal',
        subtitle: 'Adicionar animal ao rebanho',
        color: const Color(0xFF2E7D32),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CadastroScreen(initialTab: CadastroTab.animal),
          ),
        ),
      ),
      _NavItem(
        icon: Icons.house_outlined,
        label: 'Cadastrar Fazenda',
        subtitle: 'Registrar nova fazenda',
        color: const Color(0xFF6D4C41),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const CadastroScreen(initialTab: CadastroTab.fazenda),
          ),
        ),
      ),
      _NavItem(
        icon: Icons.qr_code_scanner,
        label: 'Rastreabilidade',
        subtitle: 'QR/NFC e histórico de registros',
        color: const Color(0xFF1565C0),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RastreabilidadeScreen()),
        ),
      ),
      _NavItem(
        icon: Icons.layers,
        label: 'Gestão de Lotes',
        subtitle: 'Visualizar e gerenciar lotes',
        color: const Color(0xFF6A1B9A),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LotesScreen()),
        ),
      ),
    ];

    if (cols == 1) {
      return Column(
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _NavCard(item: item),
                ))
            .toList(),
      );
    }

    // 2-column grid for tablet/desktop
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: _NavCard(item: items[i]),
                ),
              ),
              if (i + 1 < items.length)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: _NavCard(item: items[i + 1]),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

class _NavCard extends StatelessWidget {
  final _NavItem item;
  const _NavCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: item.label,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [item.color, item.color.withAlpha(210)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: item.color.withAlpha(70),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(45),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item.icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: Colors.white.withAlpha(180), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
