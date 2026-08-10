import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/empty_state.dart';
import '../inventory/widgets/product_tile.dart';
import 'search_controller.dart';

class SearchScreen extends StatefulWidget {
  final List<ProductModel> products;

  const SearchScreen({super.key, required this.products});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchNotifier _notifier;
  final TextEditingController _textController = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _notifier = SearchNotifier(widget.products);
    _textController.addListener(() {
      final hasText = _textController.text.isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _notifier.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _textController.clear();
    _notifier.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Buscar por código o descripción...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: _notifier.updateQuery,
        ),
        actions: [
          if (_hasText)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _notifier,
        builder: (context, _) {
          if (_notifier.query.isEmpty) {
            return const EmptyState(
              message: 'Escribe para buscar productos',
              icon: Icons.search,
            );
          }
          if (_notifier.results.isEmpty) {
            return EmptyState(
              message: 'No se encontraron productos para "${_notifier.query}"',
              icon: Icons.search_off,
            );
          }
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      '${_notifier.results.length} resultado${_notifier.results.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _notifier.results.length,
                  itemBuilder: (context, index) => ProductTile(
                    product: _notifier.results[index],
                    selectedSede: 'Todas',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
