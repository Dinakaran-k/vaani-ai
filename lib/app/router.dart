import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_providers.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/inventory/presentation/inventory_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/onboarding/presentation/splash_screen.dart';
import '../features/ocr/presentation/ocr_screen.dart';
import '../features/payments/presentation/payment_reminders_screen.dart';
import '../features/sales/presentation/sales_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/voice/presentation/voice_assistant_screen.dart';
import '../shared/presentation/vaani_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (kDebugMode) {
        return null;
      }

      if (authState.isLoading) {
        return null;
      }

      final location = state.uri.path;
      final isPublicRoute =
          location == '/' || location == '/onboarding' || location == '/login';
      final isAuthenticated = authState.valueOrNull != null;

      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }

      if (isAuthenticated &&
          (location == '/' ||
              location == '/onboarding' ||
              location == '/login')) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/sales', builder: (_, __) => const SalesScreen()),
      GoRoute(
        path: '/payments',
        builder: (_, __) => const PaymentRemindersScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) {
          return VaaniTabShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                builder: (_, __) => const InventoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/voice',
                builder: (_, __) => const VoiceAssistantScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/ocr', builder: (_, __) => const OcrScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
