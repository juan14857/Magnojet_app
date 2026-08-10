import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';

class StockBadge extends StatelessWidget {
  final int stock;

  const StockBadge({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    if (stock == 0) {
      color = AppColors.errorColor;
      label = 'AGOTADO';
    } else if (stock <= ApiConstants.lowStockThreshold) {
      color = AppColors.accentColor;
      label = 'BAJO';
    } else {
      color = AppColors.successColor;
      label = 'OK';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        '$stock  $label',
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
