import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  var _period = _SalesPeriod.month;

  @override
  Widget build(BuildContext context) {
    final revenue = switch (_period) {
      _SalesPeriod.today => 'Rs 18,420',
      _SalesPeriod.week => 'Rs 91,750',
      _SalesPeriod.month => 'Rs 3,82,000',
    };

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton.filledTonal(
                tooltip: 'Back to home',
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            const SizedBox(height: 8),
            const VaaniAppHeader(subtitle: 'Business Insights'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Sales Analytics',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Export report',
                  onPressed: () =>
                      showVaaniSnackBar(context, 'Sales report export queued'),
                  icon: const Icon(Icons.file_download_outlined),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Understand what is growing and what needs attention.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: VaaniTheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 18),
            SegmentedButton<_SalesPeriod>(
              segments: const [
                ButtonSegment(value: _SalesPeriod.today, label: Text('Today')),
                ButtonSegment(value: _SalesPeriod.week, label: Text('Week')),
                ButtonSegment(value: _SalesPeriod.month, label: Text('Month')),
              ],
              selected: {_period},
              onSelectionChanged: (value) {
                setState(() => _period = value.single);
              },
            ),
            const SizedBox(height: 20),
            VaaniCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_period.label.toUpperCase()} REVENUE',
                    style: const TextStyle(
                      color: VaaniTheme.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    revenue,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final value in _period.chartValues)
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
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showNewSaleSheet(context),
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    label: const Text('New sale'),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  tooltip: 'Share summary',
                  onPressed: () =>
                      showVaaniSnackBar(context, 'Sales summary prepared'),
                  icon: const Icon(Icons.share_outlined),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const VaaniSectionTitle('Top products'),
            const SizedBox(height: 12),
            _TopProduct(
              'Basmati Rice',
              'Rs 82,400',
              '+18%',
              onTap: () => _showProductInsight('Basmati Rice'),
            ),
            _TopProduct(
              'Mustard Oil',
              'Rs 52,100',
              '+11%',
              onTap: () => _showProductInsight('Mustard Oil'),
            ),
            _TopProduct(
              'Amul Milk 1L',
              'Rs 31,650',
              '-4%',
              onTap: () => _showProductInsight('Amul Milk 1L'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNewSaleSheet(BuildContext context) {
    final rootContext = context;
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: VaaniTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Record Sale',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Create a local draft now; backend billing persistence and receipt export can attach to this flow.',
                style: Theme.of(sheetContext).textTheme.bodyLarge?.copyWith(
                      color: VaaniTheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  showVaaniSnackBar(rootContext, 'Sale draft created');
                },
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('Create draft'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProductInsight(String product) {
    showVaaniSnackBar(context, '$product insight opened');
  }
}

class _TopProduct extends StatelessWidget {
  const _TopProduct(this.name, this.amount, this.trend, {required this.onTap});

  final String name;
  final String amount;
  final String trend;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final positive = !trend.startsWith('-');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
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
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amount,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
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
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _SalesPeriod {
  today('Today', [0.35, 0.52, 0.44, 0.72, 0.60, 0.9]),
  week('Week', [0.42, 0.58, 0.68, 0.54, 0.76, 0.86, 0.72]),
  month('Month', [0.45, 0.62, 0.52, 0.82, 0.68, 0.92, 0.74]);

  const _SalesPeriod(this.label, this.chartValues);

  final String label;
  final List<double> chartValues;
}
