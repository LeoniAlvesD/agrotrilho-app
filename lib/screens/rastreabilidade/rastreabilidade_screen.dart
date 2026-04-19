import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';

/// Rastreabilidade screen — shows financial benefit, latest records and CTA.
class RastreabilidadeScreen extends StatelessWidget {
  const RastreabilidadeScreen({super.key});

  static const _registros = <_Registro>[
    _Registro(
      animal: 'Boi 001 — Lote Primavera',
      tipo: 'Rastreado',
      data: '17/04/2025',
      cor: Color(0xFF2E7D32),
      icone: Icons.qr_code,
    ),
    _Registro(
      animal: 'Vaca 042 — Lote Verão',
      tipo: 'Vacinação',
      data: '16/04/2025',
      cor: Color(0xFF1565C0),
      icone: Icons.vaccines,
    ),
    _Registro(
      animal: 'Boi 017 — Lote Inverno',
      tipo: 'Rastreado',
      data: '15/04/2025',
      cor: Color(0xFF2E7D32),
      icone: Icons.qr_code,
    ),
    _Registro(
      animal: 'Novilha 008 — Lote Exportação',
      tipo: 'Pesagem',
      data: '14/04/2025',
      cor: Color(0xFFE65100),
      icone: Icons.monitor_weight,
    ),
    _Registro(
      animal: 'Boi 033 — Lote Primavera',
      tipo: 'Vacinação',
      data: '13/04/2025',
      cor: Color(0xFF1565C0),
      icone: Icons.vaccines,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final padding = ResponsiveHelper.getPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rastreabilidade'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: padding.copyWith(top: 20, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Benefício financeiro ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withAlpha(70),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(45),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.attach_money,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Benefício Financeiro',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'R\$ 4.820,00',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Valorização estimada com rastreabilidade SISBOV',
                    style: TextStyle(
                      color: Colors.white.withAlpha(210),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _StatChip(label: '47 animais', icon: Icons.pets),
                      const SizedBox(width: 8),
                      _StatChip(label: '+18% val.', icon: Icons.trending_up),
                      const SizedBox(width: 8),
                      _StatChip(label: '92% SISBOV', icon: Icons.verified),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Quick actions ───────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _ActionBtn(
                    icon: Icons.qr_code_scanner,
                    label: 'Escanear QR',
                    color: const Color(0xFF1565C0),
                    onTap: () => _snack(context, 'Scanner QR'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionBtn(
                    icon: Icons.nfc,
                    label: 'Ler NFC',
                    color: const Color(0xFF6A1B9A),
                    onTap: () => _snack(context, 'Leitura NFC'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Últimos registros ───────────────────────────────────────
            Text(
              'Últimos Registros',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ..._registros.map((r) => _RegistroCard(registro: r)),

            const SizedBox(height: 24),

            // ── CTA card ────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withAlpha(70),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(45),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.verified_outlined,
                        color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Certificar no SISBOV',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gerar relatório e enviar para certificação oficial',
                          style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _snack(context, 'SISBOV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2E7D32),
                      minimumSize: const Size(80, 40),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Iniciar',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrindo: $label'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _StatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(80), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Registro {
  final String animal;
  final String tipo;
  final String data;
  final Color cor;
  final IconData icone;

  const _Registro({
    required this.animal,
    required this.tipo,
    required this.data,
    required this.cor,
    required this.icone,
  });
}

class _RegistroCard extends StatelessWidget {
  final _Registro registro;
  const _RegistroCard({required this.registro});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: registro.cor.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(registro.icone, color: registro.cor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  registro.animal,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  registro.data,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: registro.cor.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: registro.cor.withAlpha(80)),
            ),
            child: Text(
              registro.tipo,
              style: TextStyle(
                color: registro.cor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
