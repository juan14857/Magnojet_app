import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/empty_state.dart';
import '../home/home_controller.dart';
import '../inventory/widgets/stock_badge.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final alertProducts = controller.products
        .where((p) => p.isLowStock || p.isOutOfStock)
        .toList();

    return Scaffold(
      appBar: CustomAppBar(title: 'Alertas de Stock'),
      body: alertProducts.isEmpty
          ? const EmptyState(
              message: 'Todo el inventario está en niveles normales ✅',
              icon: Icons.check_circle_outline,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: alertProducts.length,
              itemBuilder: (context, index) =>
                  _AlertTile(product: alertProducts[index]),
            ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final ProductModel product;

  const _AlertTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final isOut = product.isOutOfStock;
    final borderColor =
        isOut ? AppColors.errorColor : AppColors.accentColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: borderColor, width: 4),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                StockBadge(stock: product.totalQuantity),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              product.material,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(product.priceWithIva),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: product.stockBySede.entries
                  .where((e) => e.value > 0)
                  .map(
                    (e) => _SedeBadge(sede: e.key, stock: e.value),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SedeBadge extends StatelessWidget {
  final String sede;
  final int stock;

  const _SedeBadge({required this.sede, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.4)),
      ),
      child: Text(
        '$sede: $stock',
        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
    );
  }
}
