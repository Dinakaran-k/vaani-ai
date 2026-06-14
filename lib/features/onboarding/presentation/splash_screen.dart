import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.2,
            colors: [Color(0xFFDDF7EF), VaaniTheme.surface],
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
                  color: VaaniTheme.primaryContainer.withValues(alpha: 0.55),
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
                  Container(
                    width: 188,
                    height: 188,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: VaaniTheme.primary.withValues(alpha: 0.10),
                      boxShadow: [
                        BoxShadow(
                          color: VaaniTheme.primary.withValues(alpha: 0.18),
                          blurRadius: 64,
                          spreadRadius: 18,
                        ),
                      ],
                    ),
                    child: const Center(child: VaaniLogo(size: 118)),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Vaani AI',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: VaaniTheme.primary,
                        ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'aapka vyapar, aapki awaaz',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: VaaniTheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'YOUR BUSINESS, YOUR VOICE',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF7C7A8A),
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
        color: active ? VaaniTheme.primary : const Color(0xFFC0C1FF),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
