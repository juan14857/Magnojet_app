import '../constants/nozzle_data.dart';
import '../../data/models/product_model.dart';

// Series que se muestran primero en los resultados, en este orden exacto.
// CVIA → CV-IA, MAG CH30/MAG CH→ MAG CH, MAG 60°→ MGA 60, MAG 40°→ MGA 40.
const List<String> kPrioritySeriesCodes = [
  'BD',
  'BD-AV',
  'PB-IA',
  'ST',
  'ST-IA',
  'TM-IA',
  'MDC',
  'MJE',
  'CH100',
  'CV-IA',
  'MAG',
  'MAG CH',
  'MGA 40',
  'MGA 60',
  'MGA 90',
  'MJS',
  'MJ6',
];

class NozzleMatchService {
  static NozzleSeries? findSeriesForProduct(ProductModel product) {
    final searchText =
        '${product.material} ${product.description}'.toUpperCase();
    for (final series in kNozzleSeries) {
      for (final keyword in series.keywords) {
        if (searchText.contains(keyword.toUpperCase())) {
          return series;
        }
      }
    }
    return null;
  }

  static List<({ProductModel product, NozzleSeries series})>
      getNozzleProducts(List<ProductModel> allProducts) {
    final result = <({ProductModel product, NozzleSeries series})>[];
    for (final product in allProducts) {
      final series = findSeriesForProduct(product);
      if (series != null) {
        result.add((product: product, series: series));
      }
    }
    return result;
  }

  static List<({ProductModel product, NozzleSeries series})> filterByFlowRate({
    required List<ProductModel> allProducts,
    required double targetQ,
    DropletSize? preferredDroplet,
    JetType? preferredJetType,
  }) {
    final nozzles = getNozzleProducts(allProducts);
    final filtered = nozzles.where((n) {
      if (preferredDroplet != null) {
        if (n.series.dropletRange.isNotEmpty &&
            !n.series.dropletRange.contains(preferredDroplet)) {
          return false;
        }
      }
      if (preferredJetType != null) {
        if (n.series.jetType != preferredJetType) return false;
      }
      return true;
    }).toList();

    // Prioridad: las series del listado aparecen primero, en su orden definido.
    // Las demás series quedan al final, en el orden original.
    filtered.sort((a, b) {
      final aIdx = kPrioritySeriesCodes.indexOf(a.series.seriesCode);
      final bIdx = kPrioritySeriesCodes.indexOf(b.series.seriesCode);
      if (aIdx == -1 && bIdx == -1) return 0;
      if (aIdx == -1) return 1;
      if (bIdx == -1) return -1;
      return aIdx.compareTo(bIdx);
    });

    return filtered;
  }
}
