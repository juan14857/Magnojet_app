import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/nozzle_data.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/empty_state.dart';
import 'nozzle_calculator_controller.dart';
import 'widgets/nozzle_recommendation_tile.dart';

class NozzleCalculatorScreen extends StatefulWidget {
  final List<ProductModel> allProducts;

  const NozzleCalculatorScreen({
    super.key,
    required this.allProducts,
  });

  @override
  State<NozzleCalculatorScreen> createState() =>
      _NozzleCalculatorScreenState();
}

class _NozzleCalculatorScreenState extends State<NozzleCalculatorScreen> {
  late NozzleCalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NozzleCalculatorController(widget.allProducts);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: const _NozzleCalculatorBody(),
    );
  }
}

class _NozzleCalculatorBody extends StatefulWidget {
  const _NozzleCalculatorBody();

  @override
  State<_NozzleCalculatorBody> createState() => _NozzleCalculatorBodyState();
}

class _NozzleCalculatorBodyState extends State<_NozzleCalculatorBody> {
  final _formKey = GlobalKey<FormState>();
  final _qCtrl = TextEditingController();
  final _vCtrl = TextEditingController();
  final _eCtrl = TextEditingController();

  DropletSize? _selectedDroplet;
  JetType? _selectedJetType;

  @override
  void dispose() {
    _qCtrl.dispose();
    _vCtrl.dispose();
    _eCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final ctrl = context.read<NozzleCalculatorController>();
    ctrl.Q_input = double.parse(_qCtrl.text.replaceAll(',', '.'));
    ctrl.V = double.parse(_vCtrl.text.replaceAll(',', '.'));
    ctrl.E = double.parse(_eCtrl.text.replaceAll(',', '.'));
    ctrl.preferredDroplet = _selectedDroplet;
    ctrl.preferredJetType = _selectedJetType;
    ctrl.calculateq();
  }

  void _reset() {
    _formKey.currentState?.reset();
    _qCtrl.clear();
    _vCtrl.clear();
    _eCtrl.clear();
    setState(() {
      _selectedDroplet = null;
      _selectedJetType = null;
    });
    context.read<NozzleCalculatorController>().reset();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<NozzleCalculatorController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Selección de Boquilla (q)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputCard(ctrl),
            if (ctrl.hasCalculated) ...[
              const SizedBox(height: 12),
              _buildResultCard(ctrl),
              const SizedBox(height: 12),
              _buildRecommendationsSection(ctrl),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(NozzleCalculatorController ctrl) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Parámetros de Aplicación',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const Divider(height: 20),
              _numericField(
                _qCtrl,
                'Tasa de aplicación (Q) en L/ha',
                'Ej: 150',
              ),
              const SizedBox(height: 12),
              _numericField(
                _vCtrl,
                'Velocidad (V) en Km/h',
                'Ej: 6',
              ),
              const SizedBox(height: 12),
              _numericField(
                _eCtrl,
                'Espaciamiento entre boquillas (E) en metros',
                'Ej: 0.5',
              ),
              const SizedBox(height: 12),
              _buildDropletDropdown(),
              const SizedBox(height: 12),
              _buildJetTypeDropdown(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CALCULAR Y BUSCAR BOQUILLA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (ctrl.hasCalculated) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _reset,
                    child: const Text('LIMPIAR'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _numericField(
    TextEditingController ctrl,
    String label,
    String hint,
  ) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Campo requerido';
        final n = double.tryParse(v.replaceAll(',', '.'));
        if (n == null || n <= 0) return 'Ingrese un número positivo';
        return null;
      },
    );
  }

  Widget _buildDropletDropdown() {
    return DropdownButtonFormField<DropletSize?>(
      initialValue: _selectedDroplet,
      decoration: const InputDecoration(
        labelText: 'Tipo de gota preferido (opcional)',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('Cualquiera')),
        ...DropletSize.values.map(
          (d) => DropdownMenuItem(value: d, child: Text(_dropletLabel(d))),
        ),
      ],
      onChanged: (v) => setState(() => _selectedDroplet = v),
    );
  }

  Widget _buildJetTypeDropdown() {
    return DropdownButtonFormField<JetType?>(
      initialValue: _selectedJetType,
      decoration: const InputDecoration(
        labelText: 'Tipo de chorro preferido (opcional)',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('Cualquiera')),
        ...JetType.values.map(
          (j) => DropdownMenuItem(value: j, child: Text(_jetTypeLabel(j))),
        ),
      ],
      onChanged: (v) => setState(() => _selectedJetType = v),
    );
  }

  Widget _buildResultCard(NozzleCalculatorController ctrl) {
    return Card(
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Caudal necesario (q):',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              '${ctrl.resultq!.toStringAsFixed(2)} L/min',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fórmula: q = (Q × V × E) / 600',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '= (${ctrl.Q_input?.toStringAsFixed(2)} × ${ctrl.V?.toStringAsFixed(2)} × ${ctrl.E?.toStringAsFixed(2)}) / 600',
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection(NozzleCalculatorController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Boquillas disponibles en inventario',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (ctrl.recommendations.isEmpty)
          const EmptyState(
            icon: Icons.water_drop_outlined,
            message:
                'No se encontraron boquillas que coincidan con los filtros',
          )
        else
          ...ctrl.recommendations.map(
            (n) => NozzleRecommendationTile(
              product: n.product,
              series: n.series,
            ),
          ),
      ],
    );
  }

  String _dropletLabel(DropletSize d) {
    switch (d) {
      case DropletSize.muitoFinas:
        return 'Muy Finas';
      case DropletSize.finas:
        return 'Finas';
      case DropletSize.medias:
        return 'Medias';
      case DropletSize.grossas:
        return 'Gruesas';
      case DropletSize.muitoGrossas:
        return 'Muy Gruesas';
      case DropletSize.ultraGrossas:
        return 'Ultra Gruesas';
      case DropletSize.extremamenteGrossas:
        return 'Extremadamente Gruesas';
    }
  }

  String _jetTypeLabel(JetType j) {
    switch (j) {
      case JetType.jatoPlano:
        return 'Chorro Cortina';
      case JetType.jatoConico:
        return 'Chorro Cono Hueco';
      case JetType.jatoDefletido:
        return 'Chorro Cortina Deflectora';
      case JetType.jatoSolido:
        return 'Chorro Cono Lleno';
      case JetType.jatoEstendido:
        return 'Chorro Extendido';
    }
  }
}
