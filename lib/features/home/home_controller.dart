import 'package:flutter/foundation.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/inventory_repository.dart';

class HomeController extends ChangeNotifier {
  final InventoryRepository _repository;

  HomeController(this._repository);

  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;
  String _selectedSede = 'Todas';

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedSede => _selectedSede;

  List<ProductModel> get filteredProducts => _products;

  List<ProductModel> get lowStockProducts =>
      _products.where((p) => p.isLowStock).toList();

  List<ProductModel> get outOfStockProducts =>
      _products.where((p) => p.isOutOfStock).toList();

  int get alertCount => lowStockProducts.length + outOfStockProducts.length;

  List<ProductModel> productsForSede(String sede) {
    if (sede == 'Todas') return _products;
    return _products.where((p) => p.stockForSede(sede) > 0).toList();
  }

  List<ProductModel> searchProducts(String query) {
    if (query.trim().isEmpty) return _products;
    final q = query.toLowerCase();
    return _products
        .where((p) =>
            p.material.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }

  Future<void> loadInventory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.fetchInventory();

    _products = result.products;
    _error = result.error;
    _isLoading = false;
    notifyListeners();
  }

  void selectSede(String sede) {
    _selectedSede = sede;
    notifyListeners();
  }

  Future<void> refresh() => loadInventory();
}
