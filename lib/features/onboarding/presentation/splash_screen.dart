import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../shared/presentation/vaani_motion.dart';
import '../../../shared/presentation/vaani_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1450), () async {
      final settings = await Hive.openBox<Object?>('settings');
      final completed = settings.get('onboardingComplete') == true;
      if (mounted) context.go(completed ? '/login' : '/onboarding');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.2,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.55),
              scheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -56,
              left: -60,
              right: -40,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.55),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(140),
                    bottomRight: Radius.circular(220),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AnimatedAiGlow(
                    size: 188,
                    child: VaaniLogo(size: 118),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Vaani AI',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: scheme.primary,
                        ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'aapka vyapar, aapki awaaz',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'YOUR BUSINESS, YOUR VOICE',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                          letterSpacing: 1.8,
                        ),
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Dot(active: true),
                  _Dot(),
                  _Dot(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 14 : 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: active
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
