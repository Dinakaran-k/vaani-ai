import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';

class VaaniAppHeader extends StatelessWidget {
  const VaaniAppHeader({
    super.key,
    this.subtitle = 'Smart Inventory',
    this.showSearch = true,
  });

  final String subtitle;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
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
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E0EE)),
        boxShadow: [
          BoxShadow(
            color: VaaniTheme.primary.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class VaaniBottomNav extends StatelessWidget {
  const VaaniBottomNav({super.key, required this.current});

  final String current;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavSpec('home', Icons.home_rounded, 'Home', '/home'),
      _NavSpec('inventory', Icons.inventory_2_outlined, 'Stock', '/inventory'),
      _NavSpec('voice', Icons.graphic_eq, 'Voice', '/voice'),
      _NavSpec('scanner', Icons.document_scanner_outlined, 'Scanner', '/ocr'),
      _NavSpec('settings', Icons.settings_rounded, 'Settings', '/settings'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE4E1ED))),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final item in items)
              Expanded(
                child: _BottomNavItem(
                  item: item,
                  selected: current == item.id,
                  onTap: () => context.go(item.route),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavSpec item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: selected ? VaaniTheme.primaryContainer : null,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                item.icon,
                size: 22,
                color: selected ? VaaniTheme.primary : const Color(0xFF767586),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected ? VaaniTheme.primary : const Color(0xFF767586),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
  const _NavSpec(this.id, this.icon, this.label, this.route);

  final String id;
  final IconData icon;
  final String label;
  final String route;
}
