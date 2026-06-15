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
                const Expanded(child: _ScannerPreview()),
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
                          Expanded(
                            child: Text(
                              'Invoice Details',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(width: 12),
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
                        onPressed: () => showVaaniSnackBar(
                          context,
                          'Invoice items queued for inventory review',
                        ),
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
    );
  }
}

class _ScannerPreview extends StatefulWidget {
  const _ScannerPreview();

  @override
  State<_ScannerPreview> createState() => _ScannerPreviewState();
}

class _ScannerPreviewState extends State<_ScannerPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF303038), Color(0xFF0F172A)],
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 230,
              height: 330,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F2EA),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.38),
                    blurRadius: 36,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INVOICE',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  for (var i = 0; i < 7; i++) ...[
                    Container(
                      height: 10,
                      width: i.isEven ? 150 : 112,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8D2C7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Spacer(),
                  Container(
                    height: 14,
                    width: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCAC3B8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 320,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: VaaniTheme.primary, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Positioned(
                  top: 86 + _controller.value * 176,
                  child: Container(
                    width: 316,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: VaaniTheme.aiGradient,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: VaaniTheme.primary.withValues(alpha: 0.36),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 72,
              right: 32,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
          ],
        ),
      ),
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
