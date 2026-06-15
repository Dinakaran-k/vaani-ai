import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const products = [
      _ProductUi('Basmati Rice', 'Premium 25kg bags', 42, 'in stock', true),
      _ProductUi('Amul Milk 1L', 'Dairy and cold goods', 4, 'low stock', false),
      _ProductUi(
        'Thums Up 2L',
        'Beverages and drinks',
        0,
        'out of stock',
        false,
      ),
      _ProductUi('Surf Excel 1kg', 'Household supplies', 18, 'in stock', true),
    ];

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
                        onPressed: () {},
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip('All Items', selected: true),
                        _FilterChip('Low Stock'),
                        _FilterChip('Out of Stock'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final product in products) ...[
                    _InventoryTile(product: product),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const VaaniBottomNav(current: 'inventory'),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  const _InventoryTile({required this.product});

  final _ProductUi product;

  @override
  Widget build(BuildContext context) {
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
        showDragHandle: true,
        backgroundColor: VaaniTheme.surface,
        barrierColor: Colors.black.withValues(alpha: 0.62),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        builder: (_) => _UpdateStockSheet(product: product),
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

class _UpdateStockSheet extends StatelessWidget {
  const _UpdateStockSheet({required this.product});

  final _ProductUi product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Update Stock', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(product.name, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(72, 72),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Icon(Icons.remove),
              ),
              Text(
                product.quantity.toString(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
              OutlinedButton(
                onPressed: () {},
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(this.label, {this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? VaaniTheme.primaryContainer : Colors.white,
        side: BorderSide(
          color: selected ? VaaniTheme.primary : const Color(0xFFC7C4D7),
        ),
        labelStyle: TextStyle(
          color: selected ? VaaniTheme.primary : VaaniTheme.onSurface,
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
}
