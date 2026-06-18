import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';

class VaaniAppHeader extends StatelessWidget {
  const VaaniAppHeader({
    super.key,
    this.subtitle = 'Smart Inventory',
    this.showSearch = true,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 8),
  });

  final String subtitle;
  final bool showSearch;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          const VaaniLogo(size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vaani AI', style: Theme.of(context).textTheme.titleLarge),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: VaaniTheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (showSearch)
            IconButton(
              tooltip: 'Search',
              onPressed: () => showVaaniSearchSheet(context),
              icon: const Icon(Icons.search),
            ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => showVaaniSnackBar(context, 'No new notifications'),
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class VaaniLogo extends StatelessWidget {
  const VaaniLogo({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: VaaniTheme.aiGradient,
        boxShadow: [
          BoxShadow(
            color: VaaniTheme.primary.withValues(alpha: 0.24),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.mic_rounded, color: Colors.white, size: size * 0.38),
            Positioned(
              left: size * 0.28,
              top: size * 0.22,
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white.withValues(alpha: 0.95),
                size: size * 0.16,
              ),
            ),
            Positioned(
              right: size * 0.22,
              bottom: size * 0.26,
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white.withValues(alpha: 0.95),
                size: size * 0.13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VaaniCard extends StatelessWidget {
  const VaaniCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(VaaniTheme.radius),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E0EE)),
          borderRadius: BorderRadius.circular(VaaniTheme.radius),
          boxShadow: [
            BoxShadow(
              color: VaaniTheme.primary.withValues(alpha: 0.035),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class VaaniTabShell extends StatelessWidget {
  const VaaniTabShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: VaaniBottomNav(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class VaaniBottomNav extends StatelessWidget {
  const VaaniBottomNav({
    super.key,
    this.current,
    this.currentIndex,
    this.onDestinationSelected,
  });

  final String? current;
  final int? currentIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavSpec(
        'home',
        Icons.home_outlined,
        Icons.home_rounded,
        'Home',
        '/home',
      ),
      _NavSpec(
        'inventory',
        Icons.inventory_2_outlined,
        Icons.inventory_2_rounded,
        'Stock',
        '/inventory',
      ),
      _NavSpec(
        'voice',
        Icons.graphic_eq,
        Icons.graphic_eq,
        'Voice',
        '/voice',
      ),
      _NavSpec(
        'scanner',
        Icons.document_scanner_outlined,
        Icons.document_scanner_rounded,
        'Scanner',
        '/ocr',
      ),
      _NavSpec(
        'settings',
        Icons.settings_outlined,
        Icons.settings_rounded,
        'Settings',
        '/settings',
      ),
    ];

    final rawIndex =
        currentIndex ?? items.indexWhere((item) => item.id == current);
    final selectedIndex = rawIndex.clamp(0, items.length - 1);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        final callback = onDestinationSelected;
        if (callback != null) {
          callback(index);
          return;
        }
        if (index != selectedIndex) context.go(items[index].route);
      },
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          ),
      ],
    );
  }
}

Future<void> showVaaniSearchSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: VaaniTheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(VaaniTheme.sheetRadius),
      ),
    ),
    builder: (sheetContext) => _VaaniSearchSheet(rootContext: context),
  );
}

class _VaaniSearchSheet extends StatefulWidget {
  const _VaaniSearchSheet({required this.rootContext});

  final BuildContext rootContext;

  @override
  State<_VaaniSearchSheet> createState() => _VaaniSearchSheetState();
}

class _VaaniSearchSheetState extends State<_VaaniSearchSheet> {
  final _controller = TextEditingController();

  static const _suggestions = [
    ('Low stock items', Icons.inventory_2_outlined, '/inventory'),
    ('Scan invoice', Icons.document_scanner_outlined, '/ocr'),
    ('Open voice assistant', Icons.graphic_eq, '/voice'),
    ('Settings', Icons.settings_outlined, '/settings'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('Search Vaani', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search stock, scanner, settings...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                showVaaniSnackBar(widget.rootContext, 'Searching for "$value"');
              },
            ),
            const SizedBox(height: 14),
            for (final suggestion in _suggestions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Icon(suggestion.$2)),
                title: Text(suggestion.$1),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _openSuggestion(context, suggestion.$3),
              ),
          ],
        ),
      ),
    );
  }

  void _openSuggestion(BuildContext context, String route) {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.rootContext.mounted) {
        widget.rootContext.go(route);
      }
    });
  }
}

void showVaaniSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VaaniTheme.controlRadius),
        ),
      ),
    );
}

Future<void> showVaaniLanguageSheet(BuildContext context) {
  final rootContext = context;
  const languages = [
    ('English', 'Default'),
    ('Hindi', 'Hindi'),
    ('Tamil', 'Tamil'),
    ('Telugu', 'Telugu'),
    ('Marathi', 'Marathi'),
    ('Gujarati', 'Gujarati'),
  ];
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: VaaniTheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(VaaniTheme.sheetRadius),
      ),
    ),
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: SizedBox(
            height: MediaQuery.sizeOf(sheetContext).height * 0.62,
            child: ListView(
              children: [
                Text(
                  'Voice Language',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                for (final language in languages)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: VaaniTheme.primaryContainer,
                      child: Text(language.$1.characters.first),
                    ),
                    title: Text(language.$1),
                    subtitle: Text(language.$2),
                    trailing: language.$1 == 'English'
                        ? const Icon(
                            Icons.check_circle,
                            color: VaaniTheme.primary,
                          )
                        : null,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      showVaaniSnackBar(
                        rootContext,
                        '${language.$1} selected',
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class VaaniSectionTitle extends StatelessWidget {
  const VaaniSectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _NavSpec {
  const _NavSpec(this.id, this.icon, this.selectedIcon, this.label, this.route);

  final String id;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
}
