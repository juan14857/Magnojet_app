import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/product_model.dart';

class InventoryRepository {
  Future<({List<ProductModel> products, String? error})>
      fetchInventory() async {
    try {
      final uri = Uri.parse(ApiConstants.inventoryUrl);
      debugPrint('[Inventory] GET $uri');

      final response = await http.get(uri).timeout(
            const Duration(seconds: 15),
          );

      debugPrint('[Inventory] status=${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint('[Inventory] body=${response.body}');
        return (
          products: <ProductModel>[],
          error: 'Error HTTP ${response.statusCode}: ${response.body}'
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final values = data['values'] as List<dynamic>?;

      if (values == null || values.length <= 1) {
        return (
          products: <ProductModel>[],
          error: 'La hoja no tiene datos. Verifica el nombre de la pestaña: "${ApiConstants.sheetName}"'
        );
      }

      debugPrint('[Inventory] filas recibidas: ${values.length - 1}');

      final products = values
          .skip(1)
          .whereType<List<dynamic>>()
          .where((row) => row.isNotEmpty && row[0]?.toString().trim() != '')
          .map(ProductModel.fromSheetRow)
          .toList();

      return (products: products, error: null);
    } catch (e) {
      debugPrint('[Inventory] ERROR: $e');
      return (products: <ProductModel>[], error: e.toString());
    }
  }
}
