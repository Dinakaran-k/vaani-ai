import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_motion.dart';
import '../../../shared/presentation/vaani_shell.dart';
import '../../voice/presentation/voice_assistant_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: VaaniAppHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              sliver: SliverList.list(
                children: [
                  const VaaniEntrance(child: _SalesSummaryCard()),
                  const SizedBox(height: 16),
                  const VaaniEntrance(
                    delay: Duration(milliseconds: 90),
                    child: _AiInsightCard(),
                  ),
                  const SizedBox(height: 18),
                  VaaniEntrance(
                    delay: const Duration(milliseconds: 160),
                    child: _VoiceCommandCard(
                      onTap: () => showVoiceAssistantSheet(context),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const VaaniSectionTitle('Daily operations'),
                  const SizedBox(height: 12),
                  _OperationGrid(
                    items: [
                      _OperationItem(
                        icon: Icons.inventory_2_outlined,
                        title: 'Inventory',
                        subtitle: 'Stock updates',
                        color: VaaniTheme.primaryContainer,
                        onTap: () => context.go('/inventory'),
                      ),
                      _OperationItem(
                        icon: Icons.point_of_sale_outlined,
                        title: 'Sales',
                        subtitle: 'Billing and reports',
                        color: VaaniTheme.secondaryContainer,
                        onTap: () => context.go('/sales'),
                      ),
                      _OperationItem(
                        icon: Icons.document_scanner_outlined,
                        title: 'Scanner',
                        subtitle: 'Invoice OCR',
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        onTap: () => context.go('/ocr'),
                      ),
                      _OperationItem(
                        icon: Icons.currency_rupee_rounded,
                        title: 'Udhaar',
                        subtitle: 'Payment dues',
                        color: Theme.of(context).colorScheme.errorContainer,
                        onTap: () => context.go('/payments'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesSummaryCard extends StatelessWidget {
  const _SalesSummaryCard();

  @override
  Widget build(BuildContext context) {
    return VaaniCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'TODAY SALES',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: VaaniTheme.onSurfaceVariant,
                      letterSpacing: 0.8,
                    ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: VaaniTheme.secondaryContainer.withValues(alpha: 0.38),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '+12%',
                  style: TextStyle(
                    color: VaaniTheme.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Rs 18,420',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            '42 bills recorded by voice and scanner',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: VaaniTheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 76,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final value in const [0.35, 0.52, 0.44, 0.72, 0.60, 0.9])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FractionallySizedBox(
                        heightFactor: value,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: VaaniTheme.aiGradientFor(
                              Theme.of(context).brightness,
                            ),
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
    );
  }
}

class _AiInsightCard extends StatelessWidget {
  const _AiInsightCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          left: BorderSide(color: VaaniTheme.secondary, width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: VaaniTheme.secondary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vaani Insight',
            style: TextStyle(
              color: VaaniTheme.secondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Mustard oil is selling faster this week. Restock 24 units before evening rush.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _VoiceCommandCard extends StatelessWidget {
  const _VoiceCommandCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: VaaniTheme.aiGradientFor(Theme.of(context).brightness),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: VaaniTheme.primary.withValues(alpha: 0.22),
              blurRadius: 34,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.onPrimary.withValues(alpha: 0.20),
                border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.44)),
              ),
              child: Icon(Icons.mic_rounded, color: scheme.onPrimary, size: 34),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ask Vaani',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: scheme.onPrimary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Try: Add 20 bags rice',
                    style: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.88)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: scheme.onPrimary),
          ],
        ),
      ),
    );
  }
}

class _OperationGrid extends StatelessWidget {
  const _OperationGrid({required this.items});

  final List<_OperationItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items) SizedBox(width: width, child: item),
          ],
        );
      },
    );
  }
}

class _OperationItem extends StatelessWidget {
  const _OperationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30, color: VaaniTheme.onSurface),
              const SizedBox(height: 22),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: VaaniTheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
