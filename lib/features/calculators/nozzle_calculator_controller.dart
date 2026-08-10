import 'package:flutter/foundation.dart';
import '../../core/constants/nozzle_data.dart';
import '../../core/utils/nozzle_match_service.dart';
import '../../data/models/product_model.dart';

class NozzleCalculatorController extends ChangeNotifier {
  final List<ProductModel> allProducts;

  NozzleCalculatorController(this.allProducts);

  // Inputs
  // ignore: non_constant_identifier_names
  double? q_input; // para fórmula Q: q = caudal boquilla
  // ignore: non_constant_identifier_names
  double? Q_input; // para fórmula q: Q = tasa de aplicación
  double? V;
  double? E;
  DropletSize? preferredDroplet;
  JetType? preferredJetType;

  // Resultados
  double? resultQ;
  double? resultq;
  List<({ProductModel product, NozzleSeries series})> recommendations = [];
  bool hasCalculated = false;

  void calculateQ() {
    if (q_input == null || V == null || E == null) return;
    resultQ = (q_input! * 600) / (V! * E!);
    hasCalculated = true;
    notifyListeners();
  }

  void calculateq() {
    if (Q_input == null || V == null || E == null) return;
    resultq = (Q_input! * V! * E!) / 600;
    recommendations = NozzleMatchService.filterByFlowRate(
      allProducts: allProducts,
      targetQ: resultq!,
      preferredDroplet: preferredDroplet,
      preferredJetType: preferredJetType,
    );
    hasCalculated = true;
    notifyListeners();
  }

  void reset() {
    hasCalculated = false;
    resultQ = null;
    resultq = null;
    recommendations = [];
    notifyListeners();
  }
}
