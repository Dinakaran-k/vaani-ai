import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class PaymentRemindersScreen extends StatefulWidget {
  const PaymentRemindersScreen({super.key});

  @override
  State<PaymentRemindersScreen> createState() => _PaymentRemindersScreenState();
}

class _PaymentRemindersScreenState extends State<PaymentRemindersScreen> {
  var _filter = _DueFilterType.all;
  final _dues = <_DueUi>[
    _DueUi(
      initial: 'R',
      name: 'Rajesh Kumar',
      phone: '+91 98765 43210',
      amount: 2500,
      status: 'OVERDUE 15D',
      urgent: true,
    ),
    _DueUi(
      initial: 'A',
      name: 'Amit Sharma',
      phone: '+91 87654 32109',
      amount: 1200,
      status: 'RECENT',
    ),
    _DueUi(
      initial: 'S',
      name: 'Sunita Traders',
      phone: '+91 99887 77665',
      amount: 7800,
      status: 'OVERDUE 4D',
      urgent: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleDues = _visibleDues;
    final total = _dues.fold<int>(0, (sum, due) => sum + due.amount);

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
            const VaaniAppHeader(
              subtitle: 'Udhaar Reminders',
              padding: EdgeInsets.zero,
            ),
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
                          'Rs ${_formatAmount(total)}',
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
                            'from ${_dues.length} customers',
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
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(VaaniTheme.radius),
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
                          '${_dues.where((due) => due.urgent).length} customers need a reminder today. Tap Remind to prepare the message.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _DueFilter(
                    'All Dues (${_dues.length})',
                    selected: _filter == _DueFilterType.all,
                    onSelected: () =>
                        setState(() => _filter = _DueFilterType.all),
                  ),
                  _DueFilter(
                    'Overdue (${_dues.where((due) => due.urgent).length})',
                    selected: _filter == _DueFilterType.overdue,
                    onSelected: () =>
                        setState(() => _filter = _DueFilterType.overdue),
                  ),
                  _DueFilter(
                    'Recent (${_dues.where((due) => !due.urgent).length})',
                    selected: _filter == _DueFilterType.recent,
                    onSelected: () =>
                        setState(() => _filter = _DueFilterType.recent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (visibleDues.isEmpty)
              const VaaniCard(child: Text('No reminders in this view.')),
            for (final due in visibleDues) ...[
              _DueCard(
                due: due,
                onRemind: () => _markReminded(due),
                onTap: () => _showDueDetails(due),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }

  List<_DueUi> get _visibleDues {
    return switch (_filter) {
      _DueFilterType.all => _dues,
      _DueFilterType.overdue => _dues.where((due) => due.urgent).toList(),
      _DueFilterType.recent => _dues.where((due) => !due.urgent).toList(),
    };
  }

  void _markReminded(_DueUi due) {
    setState(() => due.reminded = true);
    showVaaniSnackBar(context, 'Reminder marked for ${due.name}');
  }

  Future<void> _showDueDetails(_DueUi due) {
    final rootContext = context;
    final scheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  due.name,
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(due.phone),
                const SizedBox(height: 18),
                VaaniCard(
                  child: Row(
                    children: [
                      const Icon(Icons.currency_rupee_rounded),
                      const SizedBox(width: 12),
                      Text(
                        'Rs ${_formatAmount(due.amount)} due',
                        style: Theme.of(sheetContext).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    if (!rootContext.mounted) return;
                    _markReminded(due);
                  },
                  icon: const Icon(Icons.message_outlined),
                  label: Text(due.reminded ? 'Send again' : 'Prepare reminder'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _formatAmount(int amount) {
    final text = amount.toString();
    if (text.length <= 3) return text;
    final head = text.substring(0, text.length - 3);
    final tail = text.substring(text.length - 3);
    return '$head,$tail';
  }
}

class _DueFilter extends StatelessWidget {
  const _DueFilter(
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
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({
    required this.due,
    required this.onRemind,
    required this.onTap,
  });

  final _DueUi due;
  final VoidCallback onRemind;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(VaaniTheme.radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: VaaniCard(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: due.urgent
                        ? scheme.errorContainer
                        : scheme.primaryContainer,
                    child: Text(
                      due.initial,
                      style: TextStyle(
                        color: due.urgent ? scheme.error : scheme.primary,
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
                              due.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label:
                                  Text(due.reminded ? 'REMINDED' : due.status),
                              backgroundColor: due.urgent
                                  ? scheme.errorContainer
                                  : scheme.surfaceContainer,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(due.phone),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
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
                          'Rs ${_PaymentRemindersScreenState._formatAmount(due.amount)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: due.urgent
                                        ? Theme.of(context).colorScheme.error
                                        : VaaniTheme.onSurface,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: onRemind,
                    icon: Icon(
                      due.reminded
                          ? Icons.check_circle_outline
                          : Icons.message_outlined,
                    ),
                    label: Text(due.reminded ? 'Reminded' : 'Remind'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DueUi {
  _DueUi({
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
  final int amount;
  final String status;
  final bool urgent;
  bool reminded = false;
}

enum _DueFilterType { all, overdue, recent }
