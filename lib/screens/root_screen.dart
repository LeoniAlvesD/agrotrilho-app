import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/platform_indicator.dart';
import 'home/home_screen.dart';
import 'lotes/lotes_screen.dart';
import 'voz/voz_screen.dart';
import 'acoes/acoes_screen.dart';
import 'animais/lista_animais.dart';
import 'scanner/qr_scanner_screen.dart';
import 'relatorios/relatorios_screen.dart';
import 'sanitary/sanitary_home_screen.dart';
import 'configuracoes/configuracoes_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  // Bottom-nav indices (mobile): Home, Lotes, Voz, Ações, Config
  // Extended nav-rail / drawer also shows: Animais, Relatórios, Sanitário
  static const _kMaxNavRailIndex = 7; // inclusive upper bound for 8 screens
  static const _titles = [
    AppStrings.appName, // 0 Home
    'Meus Lotes',       // 1 Lotes
    'Voz',              // 2 Voz
    'Ações Rápidas',    // 3 Ações
    'Animais',          // 4 Animais
    'Relatórios',       // 5 Relatórios
    'Controle Sanitário', // 6 Sanitário
    'Configurações',    // 7 Config
  ];

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const LotesScreen();
      case 2:
        return const VozScreen();
      case 3:
        return const AcoesScreen();
      case 4:
        return const ListaAnimais();
      case 5:
        return const RelatoriosScreen();
      case 6:
        return const SanitaryHomeScreen();
      case 7:
        return const ConfiguracoesScreen();
      default:
        return const HomeScreen();
    }
  }

  void _onItemSelected(int index) {
    // Index 8 is the "Scanner" shortcut – push as overlay.
    if (index == 8) {
      _openScanner();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _openScanner() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final colorScheme = Theme.of(context).colorScheme;

    return RootNav(
      goTo: _onItemSelected,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: isMobile ? 52 : 60,
          titleSpacing: isMobile ? 4 : NavigationToolbar.kMiddleSpacing,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.agriculture,
                  size: isMobile ? 22 : 28,
                  semanticLabel: AppStrings.appName),
              SizedBox(width: AppSpacing.sm),
              Text(
                _titles[_selectedIndex],
                style: TextStyle(fontSize: isMobile ? 16 : 20),
              ),
            ],
          ),
          automaticallyImplyLeading: isMobile,
          actions: const [
            PlatformIndicator(),
            SizedBox(width: AppSpacing.md),
          ],
        ),
        drawer: isMobile
            ? AppDrawer(
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemSelected,
              )
            : null,
        body: Row(
          children: [
            if (!isMobile)
              NavigationRail(
                extended: isDesktop,
                selectedIndex: _selectedIndex.clamp(0, _kMaxNavRailIndex),
                onDestinationSelected: _onItemSelected,
                backgroundColor: colorScheme.surface,
                indicatorColor: colorScheme.primary.withAlpha(30),
                leading: isDesktop
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.sm),
                        child: Icon(
                          Icons.agriculture,
                          size: 36,
                          color: colorScheme.primary,
                          semanticLabel: AppStrings.appName,
                        ),
                      )
                    : null,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.layers_outlined),
                    selectedIcon: Icon(Icons.layers),
                    label: Text('Lotes'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.mic_none),
                    selectedIcon: Icon(Icons.mic),
                    label: Text('Voz'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.bolt_outlined),
                    selectedIcon: Icon(Icons.bolt),
                    label: Text('Ações'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.pets_outlined),
                    selectedIcon: Icon(Icons.pets),
                    label: Text('Animais'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.bar_chart_outlined),
                    selectedIcon: Icon(Icons.bar_chart),
                    label: Text('Relatórios'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.health_and_safety_outlined),
                    selectedIcon: Icon(Icons.health_and_safety),
                    label: Text('Sanitário'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: Text('Config'),
                  ),
                ],
              ),
            if (!isMobile) const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(_selectedIndex),
                  child: _buildBody(),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: isMobile
            ? AppBottomNav(
                currentIndex: _selectedIndex,
                onTap: _onItemSelected,
              )
            : null,
      ),
    );
  }
}
