import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/animal_service.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/voice_command_help.dart';
import '../animais/animal_form.dart';
import '../../models/animal.dart';

/// Redesigned Home screen with large metric cards, CTA and voice command help.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AnimalService>(
      builder: (context, service, _) {
        final animais = service.animais;
        final totalAnimais = animais.length;
        final pesoTotal =
            animais.fold<double>(0, (sum, a) => sum + a.peso);
        final idadeMedia = totalAnimais > 0
            ? (animais.fold<int>(0, (sum, a) => sum + a.idade) /
                    totalAnimais)
                .toStringAsFixed(1)
            : '0';

        return SingleChildScrollView(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Greeting banner ────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withAlpha(200),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, Produtor! 👋',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Resumo do seu rebanho hoje',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(220),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Metric cards grid ───────────────────────────────────────
              Text(
                'Seu Rebanho',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _MetricsGrid(
                totalAnimais: totalAnimais,
                pesoTotal: pesoTotal,
                idadeMedia: idadeMedia,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Primary CTA ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _abrirCadastro(context, service),
                  icon: const Icon(Icons.add, size: 24),
                  label: const Text(
                    'Cadastrar Novo Animal',
                    style: TextStyle(fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Quick navigation cards ──────────────────────────────────
              Text(
                'Acesso Rápido',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _QuickAccessGrid(),

              const SizedBox(height: AppSpacing.xxl),

              // ── Voice command help ──────────────────────────────────────
              const VoiceCommandHelp(),

              const SizedBox(height: AppSpacing.xxl),

              // ── Recent animals ──────────────────────────────────────────
              if (animais.isNotEmpty)
                _buildRecentAnimals(context, animais)
              else
                _buildEmptyState(context),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }

  Future<void> _abrirCadastro(
      BuildContext context, AnimalService service) async {
    final novoAnimal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(builder: (_) => const AnimalForm()),
    );
    if (novoAnimal != null && context.mounted) {
      service.adicionar(novoAnimal);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          children: [
            Icon(Icons.pets, size: 80,
                color: colorScheme.onSurfaceVariant.withAlpha(80)),
            const SizedBox(height: AppSpacing.lg),
            Text(AppStrings.nenhumAnimal,
                style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.sm),
            Text(AppStrings.toqueNovo,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withAlpha(180))),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAnimals(BuildContext context, List<Animal> animais) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final recent = animais.length > 3 ? animais.sublist(0, 3) : animais;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.animaisRecentes,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: colorScheme.outlineVariant.withAlpha(80)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: recent
                .map(
                  (animal) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.pets,
                          color: colorScheme.primary, size: 24),
                    ),
                    title: Text(animal.nome,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        '${animal.peso} kg • ${animal.idade} '
                        '${animal.idade == 1 ? 'mês' : 'meses'}'),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ── Responsive metrics grid ─────────────────────────────────────────────────

class _MetricsGrid extends StatelessWidget {
  final int totalAnimais;
  final double pesoTotal;
  final String idadeMedia;

  const _MetricsGrid({
    required this.totalAnimais,
    required this.pesoTotal,
    required this.idadeMedia,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cards = [
      MetricCard(
        icon: Icons.pets,
        title: 'Total de Animais',
        value: '$totalAnimais',
        color: colorScheme.primary,
      ),
      MetricCard(
        icon: Icons.monitor_weight,
        title: 'Peso Total (kg)',
        value: pesoTotal.toStringAsFixed(0),
        color: const Color(0xFFF57C00),
      ),
      MetricCard(
        icon: Icons.calendar_today,
        title: 'Idade Média (meses)',
        value: idadeMedia,
        color: const Color(0xFF1976D2),
      ),
    ];

    final isMobile = ResponsiveHelper.isMobile(context);
    final columns = isMobile ? 1 : 3;

    if (columns == 1) {
      return Column(
        children: cards
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: c,
                ))
            .toList(),
      );
    }

    return Row(
      children: cards
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: c,
                ),
              ))
          .toList(),
    );
  }
}

// ── Quick-access navigation cards ───────────────────────────────────────────

class _QuickAccessGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final items = [
      _QuickItem(
        icon: Icons.layers,
        label: 'Lotes',
        color: const Color(0xFF7B1FA2),
        navIndex: 1,
      ),
      _QuickItem(
        icon: Icons.mic,
        label: 'Voz',
        color: const Color(0xFF0288D1),
        navIndex: 2,
      ),
      _QuickItem(
        icon: Icons.bolt,
        label: 'Ações',
        color: const Color(0xFFF57C00),
        navIndex: 3,
      ),
      _QuickItem(
        icon: Icons.pets,
        label: 'Animais',
        color: colorScheme.primary,
        navIndex: 4,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: items.map((item) => _QuickCard(item: item)).toList(),
    );
  }
}

class _QuickItem {
  final IconData icon;
  final String label;
  final Color color;
  final int navIndex;
  const _QuickItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.navIndex,
  });
}

class _QuickCard extends StatelessWidget {
  final _QuickItem item;
  const _QuickCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // Navigate via root screen index – resolved by notifying the parent
        // through a RootNav helper so we don't need a heavy dependency.
        RootNav.of(context)?.goTo(item.navIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          color: item.color.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: item.color.withAlpha(60)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(item.icon, color: item.color, size: 26),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                item.label,
                style: TextStyle(
                  color: item.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Simple inherited helper so HomeScreen can trigger root navigation ────────

class RootNav extends InheritedWidget {
  final void Function(int index) goTo;

  const RootNav({
    super.key,
    required this.goTo,
    required super.child,
  });

  static RootNav? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RootNav>();

  @override
  bool updateShouldNotify(RootNav old) => goTo != old.goTo;
}
