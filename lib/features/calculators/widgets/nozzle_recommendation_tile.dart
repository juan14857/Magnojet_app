import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/nozzle_data.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/product_model.dart';
import '../../inventory/inventory_screen.dart';
import '../../inventory/widgets/stock_badge.dart';

class NozzleRecommendationTile extends StatelessWidget {
  final ProductModel product;
  final NozzleSeries series;

  const NozzleRecommendationTile({
    super.key,
    required this.product,
    required this.series,
  });

  Color _dropletColor() {
    if (series.dropletRange.isEmpty) return Colors.blueGrey;
    switch (series.dropletRange.first) {
      case DropletSize.muitoFinas:
      case DropletSize.finas:
        return AppColors.successColor;
      case DropletSize.medias:
        return AppColors.accentColor;
      default:
        return AppColors.errorColor;
    }
  }

  String _jetTypeLabel() {
    switch (series.jetType) {
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

  @override
  Widget build(BuildContext context) {
    final color = _dropletColor();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Icon(Icons.water_drop_rounded, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _InfoLine('Código', product.material),
                  _InfoLine('Tipo', series.fullName),
                  _InfoLine('Gota', series.dropletDescription),
                  _InfoLine('Chorro', _jetTypeLabel()),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InventoryScreen(
                          product: product,
                          currentSede: 'Todas',
                        ),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      backgroundColor:
                          AppColors.primaryColor.withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    child: const Text(
                      'VER DETALLE',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(product.priceWithIva),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                StockBadge(stock: product.totalQuantity),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
