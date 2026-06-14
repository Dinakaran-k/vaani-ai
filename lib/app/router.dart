import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/inventory/presentation/inventory_screen.dart';
import '../features/ocr/presentation/ocr_screen.dart';
import '../features/payments/presentation/payment_reminders_screen.dart';
import '../features/sales/presentation/sales_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/inventory', builder: (_, __) => const InventoryScreen()),
      GoRoute(path: '/sales', builder: (_, __) => const SalesScreen()),
      GoRoute(path: '/ocr', builder: (_, __) => const OcrScreen()),
      GoRoute(
        path: '/payments',
        builder: (_, __) => const PaymentRemindersScreen(),
      ),
    ],
  );
});
