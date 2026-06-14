import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            const VaaniAppHeader(subtitle: 'Business Insights'),
            const SizedBox(height: 16),
            Text(
              'Sales Analytics',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Understand what is growing and what needs attention.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: VaaniTheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            VaaniCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MONTHLY REVENUE',
                    style: TextStyle(
                      color: VaaniTheme.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rs 3,82,000',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final value in const [
                          0.45,
                          0.62,
                          0.52,
                          0.82,
                          0.68,
                          0.92,
                          0.74,
                        ])
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: FractionallySizedBox(
                                heightFactor: value,
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: VaaniTheme.aiGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const VaaniSectionTitle('Top products'),
            const SizedBox(height: 12),
            const _TopProduct('Basmati Rice', 'Rs 82,400', '+18%'),
            const _TopProduct('Mustard Oil', 'Rs 52,100', '+11%'),
            const _TopProduct('Amul Milk 1L', 'Rs 31,650', '-4%'),
          ],
        ),
      ),
      bottomNavigationBar: const VaaniBottomNav(current: 'home'),
    );
  }
}

class _TopProduct extends StatelessWidget {
  const _TopProduct(this.name, this.amount, this.trend);

  final String name;
  final String amount;
  final String trend;

  @override
  Widget build(BuildContext context) {
    final positive = !trend.startsWith('-');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: VaaniCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: VaaniTheme.primaryContainer,
              child: Text(name.characters.first),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(name, style: Theme.of(context).textTheme.titleMedium),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  trend,
                  style: TextStyle(
                    color: positive
                        ? VaaniTheme.secondary
                        : Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w800,
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
