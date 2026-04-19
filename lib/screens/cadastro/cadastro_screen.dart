import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../services/animal_service.dart';
import 'package:provider/provider.dart';
import '../../models/animal.dart';

enum CadastroTab { animal, fazenda }

/// Combined cadastro screen with Animal and Fazenda tabs.
class CadastroScreen extends StatefulWidget {
  final CadastroTab initialTab;

  const CadastroScreen({
    super.key,
    this.initialTab = CadastroTab.animal,
  });

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab == CadastroTab.animal ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.pets), text: 'Animal'),
            Tab(icon: Icon(Icons.house_outlined), text: 'Fazenda'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AnimalForm(),
          _FazendaForm(),
        ],
      ),
    );
  }
}

// ── Animal form ───────────────────────────────────────────────────────────────

class _AnimalForm extends StatefulWidget {
  const _AnimalForm();

  @override
  State<_AnimalForm> createState() => _AnimalFormState();
}

class _AnimalFormState extends State<_AnimalForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _pesoCtrl = TextEditingController();
  final _idadeCtrl = TextEditingController();
  final _loteCtrl = TextEditingController();
  final _brincoCtrl = TextEditingController();

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _pesoCtrl.dispose();
    _idadeCtrl.dispose();
    _loteCtrl.dispose();
    _brincoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getPadding(context);

    return SingleChildScrollView(
      padding: padding.copyWith(top: 24, bottom: 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FormCard(
              title: 'Identificação',
              icon: Icons.badge_outlined,
              color: const Color(0xFF2E7D32),
              children: [
                _Field(
                  controller: _nomeCtrl,
                  label: 'Nome / Identificação',
                  hint: 'Ex: Boi 001',
                  icon: Icons.label_outlined,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _brincoCtrl,
                  label: 'Número do Brinco',
                  hint: 'Ex: BR001234',
                  icon: Icons.tag,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _FormCard(
              title: 'Dados Físicos',
              icon: Icons.monitor_weight_outlined,
              color: const Color(0xFFE65100),
              children: [
                _Field(
                  controller: _pesoCtrl,
                  label: 'Peso (kg)',
                  hint: 'Ex: 380',
                  icon: Icons.scale_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _idadeCtrl,
                  label: 'Idade (meses)',
                  hint: 'Ex: 24',
                  icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _FormCard(
              title: 'Localização',
              icon: Icons.location_on_outlined,
              color: const Color(0xFF1565C0),
              children: [
                _Field(
                  controller: _loteCtrl,
                  label: 'Lote',
                  hint: 'Ex: Lote Primavera',
                  icon: Icons.layers_outlined,
                ),
              ],
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Salvar Animal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    final service = context.read<AnimalService>();
    service.adicionar(
      Animal(
        nome: _nomeCtrl.text.trim(),
        peso: double.tryParse(_pesoCtrl.text.trim()) ?? 0,
        idade: int.tryParse(_idadeCtrl.text.trim()) ?? 0,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Animal cadastrado com sucesso!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }
}

// ── Fazenda form ──────────────────────────────────────────────────────────────

class _FazendaForm extends StatefulWidget {
  const _FazendaForm();

  @override
  State<_FazendaForm> createState() => _FazendaFormState();
}

class _FazendaFormState extends State<_FazendaForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _proprietarioCtrl = TextEditingController();
  final _municipioCtrl = TextEditingController();
  final _estadoCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _nirfCtrl = TextEditingController();

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _proprietarioCtrl.dispose();
    _municipioCtrl.dispose();
    _estadoCtrl.dispose();
    _areaCtrl.dispose();
    _nirfCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getPadding(context);

    return SingleChildScrollView(
      padding: padding.copyWith(top: 24, bottom: 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FormCard(
              title: 'Identificação',
              icon: Icons.house_outlined,
              color: const Color(0xFF6D4C41),
              children: [
                _Field(
                  controller: _nomeCtrl,
                  label: 'Nome da Fazenda',
                  hint: 'Ex: Fazenda São João',
                  icon: Icons.house_outlined,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _proprietarioCtrl,
                  label: 'Proprietário',
                  hint: 'Nome completo',
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _nirfCtrl,
                  label: 'NIRF / Código INCRA',
                  hint: 'Ex: 123456789',
                  icon: Icons.numbers_outlined,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _FormCard(
              title: 'Localização',
              icon: Icons.map_outlined,
              color: const Color(0xFF1565C0),
              children: [
                _Field(
                  controller: _municipioCtrl,
                  label: 'Município',
                  hint: 'Ex: Cuiabá',
                  icon: Icons.location_city_outlined,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _estadoCtrl,
                  label: 'Estado',
                  hint: 'Ex: MT',
                  icon: Icons.map_outlined,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _areaCtrl,
                  label: 'Área (hectares)',
                  hint: 'Ex: 250',
                  icon: Icons.crop_free,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Salvar Fazenda'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D4C41),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fazenda "${_nomeCtrl.text.trim()}" cadastrada!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }
}

// ── Shared form widgets ───────────────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _FormCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
