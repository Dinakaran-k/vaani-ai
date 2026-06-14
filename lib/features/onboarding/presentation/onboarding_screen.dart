import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      VaaniTheme.secondaryContainer.withValues(alpha: 0.22),
                      VaaniTheme.surface,
                    ],
                  ),
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 44, 20, 168),
              children: [
                const _MerchantIllustration(),
                const SizedBox(height: 48),
                Text.rich(
                  TextSpan(
                    text: 'Manage Business with\n',
                    children: [
                      TextSpan(
                        text: 'Voice',
                        style: TextStyle(color: VaaniTheme.primary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 20),
                Text(
                  'Add stock, record sales, and check reports just by talking. Available in Hindi, English, and more.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: VaaniTheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PagePill(active: true),
                        _PagePill(),
                        _PagePill(),
                        _PagePill(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.go('/home'),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Get Started'),
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
}

class _MerchantIllustration extends StatelessWidget {
  const _MerchantIllustration();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF8AC8B8),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: VaaniTheme.secondary.withValues(alpha: 0.14),
              blurRadius: 36,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 246,
              decoration: BoxDecoration(
                color: const Color(0xFFE6FFFA),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: const Color(0xFF102A43), width: 8),
              ),
            ),
            Positioned(
              top: 72,
              child: CircleAvatar(
                radius: 56,
                backgroundColor: const Color(0xFFFFB783),
                child: Icon(
                  Icons.storefront_rounded,
                  color: const Color(0xFF102A43),
                  size: 54,
                ),
              ),
            ),
            Positioned(
              bottom: 44,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const _MiniWaveform(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniWaveform extends StatelessWidget {
  const _MiniWaveform();

  @override
  Widget build(BuildContext context) {
    const heights = [20.0, 32.0, 42.0, 28.0, 36.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final height in heights)
          Container(
            width: 6,
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: VaaniTheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
  }
}

class _PagePill extends StatelessWidget {
  const _PagePill({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: active ? 58 : 14,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: active ? VaaniTheme.primary : const Color(0xFFE4E1ED),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
