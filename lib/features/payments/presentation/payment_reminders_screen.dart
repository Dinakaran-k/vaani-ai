import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class PaymentRemindersScreen extends StatelessWidget {
  const PaymentRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            const VaaniAppHeader(subtitle: 'Udhaar Reminders'),
            const SizedBox(height: 14),
            VaaniCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL PENDING DUES',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: VaaniTheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          'Rs 45,200',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            'from 12 customers',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: VaaniTheme.onSurfaceVariant,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: const Border(
                  left: BorderSide(color: VaaniTheme.secondary, width: 5),
                ),
              ),
              child: Text.rich(
                TextSpan(
                  text: 'Vaani Insight\n\n',
                  style: const TextStyle(
                    color: VaaniTheme.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '3 customers are highly likely to pay today based on history.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _DueFilter('All Dues (12)', selected: true),
                  _DueFilter('Overdue (4)'),
                  _DueFilter('Recent (8)'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _DueCard(
              initial: 'R',
              name: 'Rajesh Kumar',
              phone: '+91 98765 43210',
              amount: 'Rs 2,500',
              status: 'OVERDUE 15D',
              urgent: true,
            ),
            const SizedBox(height: 14),
            const _DueCard(
              initial: 'A',
              name: 'Amit Sharma',
              phone: '+91 87654 32109',
              amount: 'Rs 1,200',
              status: 'RECENT',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const VaaniBottomNav(current: 'home'),
    );
  }
}

class _DueFilter extends StatelessWidget {
  const _DueFilter(this.label, {this.selected = false});

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
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({
    required this.initial,
    required this.name,
    required this.phone,
    required this.amount,
    required this.status,
    this.urgent = false,
  });

  final String initial;
  final String name;
  final String phone;
  final String amount;
  final String status;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    return VaaniCard(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: urgent
                    ? const Color(0xFFFFDAD6)
                    : VaaniTheme.primaryContainer,
                child: Text(
                  initial,
                  style: TextStyle(
                    color: urgent
                        ? Theme.of(context).colorScheme.error
                        : VaaniTheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(status),
                          backgroundColor: urgent
                              ? const Color(0xFFFFDAD6)
                              : VaaniTheme.surfaceContainer,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(phone),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          Wrap(
            spacing: 14,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Due Amount'),
                    const SizedBox(height: 4),
                    Text(
                      amount,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: urgent
                                ? Theme.of(context).colorScheme.error
                                : VaaniTheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => showVaaniSnackBar(
                  context,
                  'Reminder prepared for $name',
                ),
                icon: const Icon(Icons.message_outlined),
                label: const Text('Remind'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
