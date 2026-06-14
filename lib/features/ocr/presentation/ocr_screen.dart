import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class OcrScreen extends StatelessWidget {
  const OcrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const VaaniAppHeader(subtitle: 'Invoice Scanner'),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=900&q=70',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.42),
                      child: Center(
                        child: Container(
                          width: 320,
                          height: 220,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: VaaniTheme.primary,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Total: Rs 12,450',
                                style: TextStyle(
                                  color: VaaniTheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.43,
              minChildSize: 0.32,
              maxChildSize: 0.78,
              builder: (context, controller) {
                return Container(
                  decoration: const BoxDecoration(
                    color: VaaniTheme.surface,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                    children: [
                      Center(
                        child: Container(
                          width: 58,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC7C4D7),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Invoice Details',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          const Chip(
                            label: Text('AI Scanned'),
                            avatar: Icon(Icons.bolt, size: 18),
                            backgroundColor: VaaniTheme.primary,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const _InvoiceItem(
                        icon: Icons.shopping_bag_outlined,
                        name: 'Rice (Premium 25kg)',
                        qty: 'Qty: 10 bags',
                        amount: 'Rs 8,500',
                      ),
                      const SizedBox(height: 12),
                      const _InvoiceItem(
                        icon: Icons.water_drop_outlined,
                        name: 'Mustard Oil (1L)',
                        qty: 'Qty: 24 units',
                        amount: 'Rs 3,950',
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_business_outlined),
                        label: const Text('Add items to inventory'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const VaaniBottomNav(current: 'scanner'),
    );
  }
}

class _InvoiceItem extends StatelessWidget {
  const _InvoiceItem({
    required this.icon,
    required this.name,
    required this.qty,
    required this.amount,
  });

  final IconData icon;
  final String name;
  final String qty;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return VaaniCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                VaaniTheme.secondaryContainer.withValues(alpha: 0.35),
            child: Icon(icon, color: VaaniTheme.secondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                Text(qty),
              ],
            ),
          ),
          Text(amount, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
