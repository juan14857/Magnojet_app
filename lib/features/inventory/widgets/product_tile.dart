import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/product_model.dart';
import '../inventory_screen.dart';
import 'stock_badge.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;
  final String selectedSede;

  const ProductTile({
    super.key,
    required this.product,
    required this.selectedSede,
  });

  @override
  Widget build(BuildContext context) {
    final stock = selectedSede == 'Todas'
        ? product.totalQuantity
        : product.stockForSede(selectedSede);

    final initials = product.material.length >= 2
        ? product.material.substring(0, 2).toUpperCase()
        : product.material.toUpperCase();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InventoryScreen(
              product: product,
              currentSede: selectedSede,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 20,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${product.material}  •  ${CurrencyFormatter.format(product.priceWithIva)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StockBadge(stock: stock),
                  const SizedBox(height: 4),
                  Text(
                    '$stock uds',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
