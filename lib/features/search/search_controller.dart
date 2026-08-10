import 'package:flutter/foundation.dart';
import '../../data/models/product_model.dart';

class SearchNotifier extends ChangeNotifier {
  final List<ProductModel> _allProducts;

  SearchNotifier(this._allProducts);

  String _query = '';
  String get query => _query;

  void updateQuery(String query) {
    _query = query;
    notifyListeners();
  }

  void search(String query) => updateQuery(query);

  void clear() {
    _query = '';
    notifyListeners();
  }

  List<ProductModel> get results {
    if (_query.trim().isEmpty) return [];
    final q = _query.toLowerCase();
    return _allProducts
        .where((p) =>
            p.material.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }
}
