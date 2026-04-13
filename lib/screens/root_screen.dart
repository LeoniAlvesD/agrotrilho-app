import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_bottom_nav.dart';
import 'home/dashboard_screen.dart';
import 'animais/lista_animais.dart';
import 'scanner/qr_scanner_screen.dart';
import 'relatorios/relatorios_screen.dart';
import 'configuracoes/configuracoes_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  static const _titles = [
    AppStrings.appName,
    'Animais',
    'Scanner',
    'Relatórios',
    'Configurações',
  ];

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const ListaAnimais();
      case 2:
        return const _ScannerPlaceholder();
      case 3:
        return const RelatoriosScreen();
      case 4:
        return const ConfiguracoesScreen();
      default:
        return const DashboardScreen();
    }
  }

  void _onItemSelected(int index) {
    if (index == 2) {
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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.agriculture, size: 28,
                semanticLabel: AppStrings.appName),
            SizedBox(width: AppSpacing.sm),
            Text(_titles[_selectedIndex]),
          ],
        ),
        automaticallyImplyLeading: isMobile,
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
              selectedIndex: _selectedIndex,
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
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.pets_outlined),
                  selectedIcon: Icon(Icons.pets),
                  label: Text('Animais'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.qr_code_scanner_outlined),
                  selectedIcon: Icon(Icons.qr_code_scanner),
                  label: Text('Scanner'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: Text('Relatórios'),
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
    );
  }
}

class _ScannerPlaceholder extends StatelessWidget {
  const _ScannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 80,
            color: colorScheme.onSurfaceVariant.withAlpha(80),
            semanticLabel: 'Scanner QR Code',
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Toque no botão Scanner para abrir a câmera',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
