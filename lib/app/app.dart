import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../data/repositories/inventory_repository.dart';
import '../features/alerts/alerts_screen.dart';
import '../features/calculators/nozzle_calculator_screen.dart';
import '../features/calculators/q_calculator_screen.dart';
import '../features/catalog/catalog_screen.dart';
import '../features/home/home_controller.dart';
import '../features/home/home_screen.dart';

class MagnojetApp extends StatelessWidget {
  const MagnojetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(InventoryRepository()),
      child: MaterialApp(
        title: 'Magnojet',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        routes: {
          '/alerts': (_) => const AlertsScreen(),
          '/calculator-q': (_) => const QCalculatorScreen(),
          '/calculator-nozzle': (_) =>
              const NozzleCalculatorScreen(allProducts: []),
          '/catalog': (_) => const CatalogScreen(),
        },
      ),
    );
  }
}
