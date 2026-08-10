import 'package:flutter/foundation.dart';
import '../../data/models/product_model.dart';

class InventoryController extends ChangeNotifier {
  final List<ProductModel> products;

  InventoryController(this.products);
}
