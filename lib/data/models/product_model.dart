import '../../core/constants/api_constants.dart';
import '../../core/utils/sheets_parser.dart';

const List<String> kSedes = ['Bogotá', 'Cereté', 'Villavicencio', 'Yopal'];

class ProductModel {
  final String material;
  final String description;
  final double price;
  final double ivaPercent;
  final double priceWithIva;
  final int totalQuantity;
  final Map<String, int> stockBySede;

  const ProductModel({
    required this.material,
    required this.description,
    required this.price,
    required this.ivaPercent,
    required this.priceWithIva,
    required this.totalQuantity,
    required this.stockBySede,
  });

  factory ProductModel.fromSheetRow(List<dynamic> row) {
    String get(int i) =>
        i < row.length ? (row[i]?.toString().trim() ?? '') : '';

    return ProductModel(
      material: get(0),
      description: get(1),
      price: SheetsParser.parsePrice(get(2)),
      ivaPercent: SheetsParser.parsePrice(get(3)),
      priceWithIva: SheetsParser.parsePrice(get(4)),
      totalQuantity: SheetsParser.parseStock(get(5)),
      stockBySede: {
        'Bogotá': SheetsParser.parseStock(get(6)),
        'Cereté': SheetsParser.parseStock(get(7)),
        'Villavicencio': SheetsParser.parseStock(get(8)),
        'Yopal': SheetsParser.parseStock(get(9)),
      },
    );
  }

  bool get isLowStock =>
      totalQuantity > 0 && totalQuantity <= ApiConstants.lowStockThreshold;

  bool get isOutOfStock => totalQuantity == 0;

  int stockForSede(String sede) => stockBySede[sede] ?? 0;

  ProductModel copyWith({
    String? material,
    String? description,
    double? price,
    double? ivaPercent,
    double? priceWithIva,
    int? totalQuantity,
    Map<String, int>? stockBySede,
  }) {
    return ProductModel(
      material: material ?? this.material,
      description: description ?? this.description,
      price: price ?? this.price,
      ivaPercent: ivaPercent ?? this.ivaPercent,
      priceWithIva: priceWithIva ?? this.priceWithIva,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      stockBySede: stockBySede ?? this.stockBySede,
    );
  }

  Map<String, dynamic> toJson() => {
        'material': material,
        'description': description,
        'price': price,
        'ivaPercent': ivaPercent,
        'priceWithIva': priceWithIva,
        'totalQuantity': totalQuantity,
        'stockBySede': stockBySede,
      };
}
