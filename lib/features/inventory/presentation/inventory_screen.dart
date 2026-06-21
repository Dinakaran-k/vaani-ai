import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _searchController = TextEditingController();
  var _selectedFilter = _InventoryFilter.all;
  late final List<_ProductUi> _products = [
    const _ProductUi('Basmati Rice', 'Premium 25kg bags', 42, 'in stock', true),
    const _ProductUi(
      'Amul Milk 1L',
      'Dairy and cold goods',
      4,
      'low stock',
      false,
    ),
    const _ProductUi(
      'Thums Up 2L',
      'Beverages and drinks',
      0,
      'out of stock',
      false,
    ),
    const _ProductUi(
      'Surf Excel 1kg',
      'Household supplies',
      18,
      'in stock',
      true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: VaaniAppHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              sliver: SliverList.list(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search inventory...',
                            prefixIcon: const Icon(Icons.search),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(56, 56),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: _showAddProductSheet,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          'All Items',
                          selected: _selectedFilter == _InventoryFilter.all,
                          onSelected: () => _selectFilter(_InventoryFilter.all),
                        ),
                        _FilterChip(
                          'Low Stock',
                          selected:
                              _selectedFilter == _InventoryFilter.lowStock,
                          onSelected: () =>
                              _selectFilter(_InventoryFilter.lowStock),
                        ),
                        _FilterChip(
                          'Out of Stock',
                          selected:
                              _selectedFilter == _InventoryFilter.outOfStock,
                          onSelected: () =>
                              _selectFilter(_InventoryFilter.outOfStock),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (products.isEmpty)
                    VaaniCard(
                      child: Text(
                        'No products match this view.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  for (final product in products) ...[
                    _InventoryTile(
                      product: product,
                      onSaved: (quantity) => _updateQuantity(product, quantity),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_ProductUi> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return _products.where((product) {
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.subtitle.toLowerCase().contains(query);
      final matchesFilter = switch (_selectedFilter) {
        _InventoryFilter.all => true,
        _InventoryFilter.lowStock => product.quantity > 0 && !product.healthy,
        _InventoryFilter.outOfStock => product.quantity == 0,
      };
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _selectFilter(_InventoryFilter filter) {
    setState(() => _selectedFilter = filter);
  }

  void _updateQuantity(_ProductUi product, int quantity) {
    final index = _products.indexOf(product);
    if (index == -1) return;
    setState(() {
      _products[index] = product.withQuantity(quantity);
    });
    showVaaniSnackBar(context, '${product.name} stock updated');
  }

  Future<void> _showAddProductSheet() async {
    final scheme = Theme.of(context).colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _AddProductSheet(
        onAdd: (name, category, quantity) {
          setState(() {
            _products.insert(
              0,
              _ProductUi(
                name,
                category.isEmpty ? 'General stock' : category,
                quantity,
                quantity == 0
                    ? 'out of stock'
                    : quantity < 8
                        ? 'low stock'
                        : 'in stock',
                quantity >= 8,
              ),
            );
          });
          showVaaniSnackBar(context, '$name added to inventory');
        },
      ),
    );
  }
}

class _AddProductSheet extends StatefulWidget {
  const _AddProductSheet({required this.onAdd});

  final void Function(String name, String category, int quantity) onAdd;

  @override
  State<_AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<_AddProductSheet> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          8,
          24,
          28 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Product', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Product name',
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _categoryController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Opening quantity',
                prefixIcon: Icon(Icons.add_box_outlined),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _addProduct,
              icon: const Icon(Icons.add),
              label: const Text('Add product'),
            ),
          ],
        ),
      ),
    );
  }

  void _addProduct() {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (name.isEmpty || quantity < 0) {
      showVaaniSnackBar(context, 'Add a product name and valid quantity');
      return;
    }
    Navigator.of(context).pop();
    widget.onAdd(name, category, quantity);
  }
}

class _InventoryTile extends StatelessWidget {
  const _InventoryTile({required this.product, required this.onSaved});

  final _ProductUi product;
  final ValueChanged<int> onSaved;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusColor = product.healthy
        ? VaaniTheme.secondary
        : product.quantity == 0
            ? Theme.of(context).colorScheme.error
            : const Color(0xFFB55D00);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        backgroundColor: scheme.surface,
        barrierColor: scheme.scrim.withValues(alpha: 0.62),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        builder: (_) => _UpdateStockSheet(product: product, onSaved: onSaved),
      ),
      child: VaaniCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.inventory_2_outlined, color: statusColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: VaaniTheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${product.quantity} pcs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  product.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdateStockSheet extends StatefulWidget {
  const _UpdateStockSheet({required this.product, required this.onSaved});

  final _ProductUi product;
  final ValueChanged<int> onSaved;

  @override
  State<_UpdateStockSheet> createState() => _UpdateStockSheetState();
}

class _UpdateStockSheetState extends State<_UpdateStockSheet> {
  late var _quantity = widget.product.quantity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Stock', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _quantity == 0
                      ? null
                      : () => setState(() => _quantity -= 1),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(72, 72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Icon(Icons.remove),
                ),
                Text(
                  _quantity.toString(),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                OutlinedButton(
                  onPressed: () => setState(() => _quantity += 1),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(72, 72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  child: const Icon(Icons.add, color: VaaniTheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      widget.onSaved(_quantity);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(
    this.label, {
    required this.onSelected,
    this.selected = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        backgroundColor: selected ? scheme.primaryContainer : scheme.surface,
        side: BorderSide(
          color: selected ? scheme.primary : scheme.outlineVariant,
        ),
        labelStyle: TextStyle(
          color: selected ? scheme.primary : scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProductUi {
  const _ProductUi(
    this.name,
    this.subtitle,
    this.quantity,
    this.status,
    this.healthy,
  );

  final String name;
  final String subtitle;
  final int quantity;
  final String status;
  final bool healthy;

  _ProductUi withQuantity(int quantity) {
    final status = quantity == 0
        ? 'out of stock'
        : quantity < 8
            ? 'low stock'
            : 'in stock';
    return _ProductUi(name, subtitle, quantity, status, quantity >= 8);
  }
}

enum _InventoryFilter { all, lowStock, outOfStock }
