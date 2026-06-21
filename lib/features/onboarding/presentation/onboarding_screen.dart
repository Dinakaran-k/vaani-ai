import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_motion.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  var _index = 0;

  static const _pages = [
    _OnboardingPageData(
      title: 'Manage Business with',
      highlight: 'Voice',
      body:
          'Add stock, record sales, and check reports just by talking. Available in Hindi, English, and more.',
      icon: Icons.graphic_eq,
      color: Color(0xFF8AC8B8),
    ),
    _OnboardingPageData(
      title: 'Scan Invoices with',
      highlight: 'AI OCR',
      body:
          'Capture paper bills, extract GST details, and prepare inventory updates in seconds.',
      icon: Icons.document_scanner_outlined,
      color: Color(0xFFE1E0FF),
    ),
    _OnboardingPageData(
      title: 'Track Udhaar and',
      highlight: 'Payments',
      body:
          'See pending dues, identify likely payers, and send polite reminders over WhatsApp or SMS.',
      icon: Icons.currency_rupee_rounded,
      color: Color(0xFFFFDCC5),
    ),
    _OnboardingPageData(
      title: 'Grow with',
      highlight: 'Insights',
      body:
          'Ask Vaani what is selling, what is low, and what needs attention before the rush begins.',
      icon: Icons.auto_graph_rounded,
      color: Color(0xFF6CF8BB),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.1,
                    colors: [
                      _pages[_index].color.withValues(alpha: 0.25),
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
              ),
            ),
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (context, index) {
                final page = _pages[index];
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 44, 20, 182),
                  children: [
                    _OnboardingIllustration(page: page),
                    const SizedBox(height: 48),
                    Text.rich(
                      TextSpan(
                        text: '${page.title}\n',
                        children: [
                          TextSpan(
                            text: page.highlight,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      page.body,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: VaaniTheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F4648D4),
                      blurRadius: 28,
                      offset: Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < _pages.length; i++)
                          _PagePill(active: i == _index),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => isLast ? _finish() : _nextPage(),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(isLast ? 'Start Using Vaani' : 'Get Started'),
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finish() async {
    final settings = await Hive.openBox<Object?>('settings');
    await settings.put('onboardingComplete', true);
    if (mounted) context.go('/login');
  }

  void _nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }
}

class _OnboardingIllustration extends StatelessWidget {
  const _OnboardingIllustration({required this.page});

  final _OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: page.color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: page.color.withValues(alpha: 0.28),
              blurRadius: 36,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 162,
              height: 246,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(34),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 8,
                ),
              ),
            ),
            AnimatedAiGlow(
              size: 154,
              glowColor: page.color,
              child: CircleAvatar(
                radius: 58,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Icon(
                  page.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 58,
                ),
              ),
            ),
            Positioned(
              bottom: 44,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .scrim
                          .withValues(alpha: 0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const AnimatedVaaniWaveform(
                  barCount: 5,
                  width: 6,
                  minHeight: 18,
                  maxHeight: 44,
                  spacing: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PagePill extends StatelessWidget {
  const _PagePill({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: active ? 58 : 14,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: active
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.highlight,
    required this.body,
    required this.icon,
    required this.color,
  });

  final String title;
  final String highlight;
  final String body;
  final IconData icon;
  final Color color;
}
