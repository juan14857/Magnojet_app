import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class QCalculatorScreen extends StatefulWidget {
  const QCalculatorScreen({super.key});

  @override
  State<QCalculatorScreen> createState() => _QCalculatorScreenState();
}

class _QCalculatorScreenState extends State<QCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _qCtrl = TextEditingController();
  final _vCtrl = TextEditingController();
  final _eCtrl = TextEditingController();

  double? _resultQ;
  double? _usedQ;
  double? _usedV;
  double? _usedE;

  @override
  void dispose() {
    _qCtrl.dispose();
    _vCtrl.dispose();
    _eCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final q = double.parse(_qCtrl.text.replaceAll(',', '.'));
    final v = double.parse(_vCtrl.text.replaceAll(',', '.'));
    final e = double.parse(_eCtrl.text.replaceAll(',', '.'));
    setState(() {
      _resultQ = (q * 600) / (v * e);
      _usedQ = q;
      _usedV = v;
      _usedE = e;
    });
  }

  void _reset() {
    setState(() {
      _resultQ = null;
      _usedQ = null;
      _usedV = null;
      _usedE = null;
    });
    _qCtrl.clear();
    _vCtrl.clear();
    _eCtrl.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Tasa de Aplicación (Q)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Parámetros de Pulverización',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Divider(height: 20),
                      _numericField(
                        _qCtrl,
                        'Caudal de la boquilla (q) en L/min',
                        'Ej: 0.75',
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
                      const SizedBox(height: 20),
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
                            'CALCULAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_resultQ != null) ...[
              const SizedBox(height: 12),
              _buildResultCard(),
            ],
            const SizedBox(height: 32),
          ],
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

  Widget _buildResultCard() {
    return Card(
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tasa de Aplicación',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              '${_resultQ!.toStringAsFixed(2)} L/ha',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Fórmula aplicada: Q = (q × 600) / (V × E)',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '= (${_usedQ!.toStringAsFixed(2)} × 600) / (${_usedV!.toStringAsFixed(2)} × ${_usedE!.toStringAsFixed(2)})',
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _reset,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white54),
                ),
                child: const Text(
                  'LIMPIAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
