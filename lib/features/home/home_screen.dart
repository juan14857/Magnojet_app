import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/loading_widget.dart';
import '../calculators/nozzle_calculator_screen.dart';
import '../calculators/q_calculator_screen.dart';
import '../catalog/catalog_screen.dart';
import '../inventory/widgets/product_tile.dart';
import '../search/search_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _sedes = [
    'Todas',
    'Bogotá',
    'Cereté',
    'Villavicencio',
    'Yopal',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().loadInventory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.warehouse_rounded, color: Colors.white, size: 26),
        ),
        title: const Text(
          'Magnojet',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Actualizar',
            onPressed: controller.isLoading ? null : controller.refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(controller),
          _buildCalculatorButtons(context, controller),
          _buildCatalogButton(context),
          _buildSedeChips(controller),
          if (controller.alertCount > 0 && !controller.isLoading)
            _buildAlertBanner(context, controller),
          Expanded(child: _buildBody(controller)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchScreen(products: controller.products),
          ),
        ),
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(HomeController controller) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _StatBox(
                label: 'Productos',
                value: controller.products.length.toString(),
                icon: Icons.inventory_2_rounded,
              ),
              const VerticalDivider(
                  color: Colors.white30, thickness: 1, indent: 4, endIndent: 4),
              _StatBox(
                label: 'Alertas',
                value: controller.alertCount.toString(),
                icon: Icons.warning_amber_rounded,
                alert: controller.alertCount > 0,
              ),
              const VerticalDivider(
                  color: Colors.white30, thickness: 1, indent: 4, endIndent: 4),
              _StatBox(
                label: 'Sede',
                value: controller.selectedSede,
                icon: Icons.location_on_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorButtons(
      BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calculate_outlined, color: Colors.white),
                label: const Text(
                  'Tasa de\nAplicación (Q)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const QCalculatorScreen()),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.water_drop_outlined,
                    color: Colors.white),
                label: const Text(
                  'Selección de\nBoquilla (q)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF388E3C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NozzleCalculatorScreen(
                        allProducts: controller.products),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.menu_book_rounded, color: Colors.white),
          label: const Text(
            'Catálogo V40 Digital',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5C3D8F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CatalogScreen()),
          ),
        ),
      ),
    );
  }

  Widget _buildSedeChips(HomeController controller) {
    return Container(
      height: 52,
      color: AppColors.surfaceColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemCount: _sedes.length,
        itemBuilder: (context, index) {
          final sede = _sedes[index];
          final isSelected = controller.selectedSede == sede;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(sede),
              selected: isSelected,
              onSelected: (_) => controller.selectSede(sede),
              selectedColor: AppColors.primaryColor,
              backgroundColor: AppColors.backgroundColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.textSecondary.withValues(alpha: 0.4),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAlertBanner(BuildContext context, HomeController controller) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/alerts'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF3E0),
          border: Border(
            left: BorderSide(color: AppColors.accentColor, width: 4),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppColors.accentColor, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '⚠️  ${controller.alertCount} producto${controller.alertCount == 1 ? '' : 's'} con stock bajo o agotado',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.accentColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(HomeController controller) {
    if (controller.isLoading) return const LoadingWidget();

    if (controller.error != null && controller.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded,
                  size: 56, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                controller.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: controller.refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.filteredProducts.isEmpty) return const EmptyState();

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: controller.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 88, top: 4),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (context, index) => ProductTile(
          product: controller.filteredProducts[index],
          selectedSede: controller.selectedSede,
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool alert;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    this.alert = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = alert ? AppColors.accentColor : Colors.white;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
