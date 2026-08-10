import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/product_model.dart';
import 'widgets/stock_badge.dart';

class InventoryScreen extends StatelessWidget {
  final ProductModel product;
  final String currentSede;

  const InventoryScreen({
    super.key,
    required this.product,
    required this.currentSede,
  });

  int get _maxStock => kSedes
      .map((s) => product.stockForSede(s))
      .fold(0, (max, val) => val > max ? val : max);

  Color _stockColor(int stock) {
    if (stock == 0) return AppColors.errorColor;
    if (stock <= ApiConstants.lowStockThreshold) return AppColors.accentColor;
    return AppColors.successColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.material,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              product.description,
              style:
                  const TextStyle(fontSize: 11, color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildInfoCard(),
            const SizedBox(height: 12),
            _buildStockBySedeCard(),
            const SizedBox(height: 12),
            _buildTotalCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del producto',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary),
            ),
            const Divider(height: 20),
            _InfoRow(label: 'Código', value: product.material),
            const SizedBox(height: 8),
            _InfoRow(label: 'Descripción', value: product.description),
            const Divider(height: 20),
            _InfoRow(
              label: 'Precio sin IVA',
              value: CurrencyFormatter.format(product.price),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'IVA',
              value: '${product.ivaPercent.toInt()}%',
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Precio con IVA',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 15),
                ),
                Text(
                  CurrencyFormatter.format(product.priceWithIva),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockBySedeCard() {
    final maxStock = _maxStock;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stock por sede',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            ...kSedes.map((sede) {
              final stock = product.stockForSede(sede);
              final progress =
                  maxStock > 0 ? (stock / maxStock).clamp(0.0, 1.0) : 0.0;
              final isCurrentSede =
                  sede == currentSede && currentSede != 'Todas';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCurrentSede
                      ? AppColors.primaryColor.withValues(alpha: 0.06)
                      : null,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: isCurrentSede
                      ? Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.3))
                      : Border.all(color: Colors.transparent),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (isCurrentSede)
                          const Icon(Icons.location_on,
                              size: 14, color: AppColors.primaryColor),
                        if (isCurrentSede) const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            sede,
                            style: TextStyle(
                              fontWeight: isCurrentSede
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isCurrentSede
                                  ? AppColors.primaryColor
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '$stock',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        StockBadge(stock: stock),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          AlwaysStoppedAnimation(_stockColor(stock)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stock total',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                Text(
                  '${product.totalQuantity} uds',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            if (product.isOutOfStock) ...[
              const SizedBox(height: 10),
              _AlertBox(
                icon: Icons.block,
                color: AppColors.errorColor,
                message: '🚫 Producto agotado',
              ),
            ] else if (product.isLowStock) ...[
              const SizedBox(height: 10),
              _AlertBox(
                icon: Icons.warning_amber_rounded,
                color: AppColors.accentColor,
                message: '⚠️ Stock bajo — considerar reabastecimiento',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _AlertBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;

  const _AlertBox(
      {required this.icon, required this.color, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
