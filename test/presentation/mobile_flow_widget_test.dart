import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaani_ai/app/theme.dart';
import 'package:vaani_ai/features/auth/presentation/login_screen.dart';
import 'package:vaani_ai/features/dashboard/presentation/dashboard_screen.dart';
import 'package:vaani_ai/features/inventory/presentation/inventory_screen.dart';
import 'package:vaani_ai/features/ocr/presentation/ocr_screen.dart';
import 'package:vaani_ai/features/onboarding/presentation/onboarding_screen.dart';
import 'package:vaani_ai/features/payments/presentation/payment_reminders_screen.dart';
import 'package:vaani_ai/features/sales/presentation/sales_screen.dart';
import 'package:vaani_ai/features/settings/presentation/settings_screen.dart';
import 'package:vaani_ai/features/voice/presentation/voice_assistant_sheet.dart';
import 'package:vaani_ai/features/voice/presentation/voice_assistant_screen.dart';

void main() {
  Future<void> pumpRoute(
    WidgetTester tester,
    String initialLocation, {
    Size viewport = const Size(390, 844),
  }) async {
    tester.view.physicalSize = viewport;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const DashboardScreen()),
        GoRoute(
          path: '/inventory',
          builder: (_, __) => const InventoryScreen(),
        ),
        GoRoute(path: '/sales', builder: (_, __) => const SalesScreen()),
        GoRoute(
          path: '/voice',
          builder: (_, __) => const VoiceAssistantScreen(),
        ),
        GoRoute(
          path: '/ocr',
          builder: (_, __) => const OcrScreen(cameraEnabled: false),
        ),
        GoRoute(
          path: '/payments',
          builder: (_, __) => const PaymentRemindersScreen(),
        ),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        GoRoute(
          path: '/onboarding',
          builder: (_, __) => const OnboardingScreen(),
        ),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: VaaniTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 650));
  }

  group('Stitch mobile UI flow', () {
    testWidgets('home shows dashboard command center', (tester) async {
      await pumpRoute(tester, '/home');

      expect(find.text('Vaani AI'), findsOneWidget);
      expect(find.text('TODAY SALES'), findsOneWidget);
      expect(find.text('Rs 18,420'), findsOneWidget);
      expect(find.text('Vaani Insight'), findsOneWidget);
      expect(find.text('Ask Vaani'), findsOneWidget);
      await tester.ensureVisible(find.text('Daily operations'));
      expect(find.text('Daily operations'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Inventory'),
        90,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Inventory'), findsWidgets);
      expect(find.text('Sales'), findsWidgets);
    });

    testWidgets('Ask Vaani opens modal and toggles local state',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: VaaniTheme.light(),
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: Center(
                    child: FilledButton(
                      onPressed: () => showVoiceAssistantSheet(context),
                      child: const Text('Ask Vaani'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Ask Vaani'));
      await tester.pump(const Duration(milliseconds: 450));

      expect(find.text('Ask Vaani'), findsOneWidget);
      expect(find.text('How can I help your shop?'), findsOneWidget);
      expect(find.text('Listening'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.language_rounded));
      await tester.pump(const Duration(milliseconds: 450));

      expect(find.text('Voice Language'), findsOneWidget);
    });

    testWidgets('home exposes mobile section entry points', (
      tester,
    ) async {
      await pumpRoute(tester, '/home');

      await tester.scrollUntilVisible(
        find.text('Inventory'),
        90,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Inventory'), findsWidgets);
      expect(find.text('Stock updates'), findsOneWidget);
      expect(find.text('Sales'), findsWidgets);
      expect(find.text('Billing and reports'), findsOneWidget);
      expect(find.text('Invoice OCR'), findsOneWidget);
      expect(find.text('Payment dues'), findsOneWidget);
    });

    testWidgets('global search sheet navigates to scanner', (tester) async {
      await pumpRoute(tester, '/home');

      await tester.tap(find.byTooltip('Search'));
      await tester.pumpAndSettle();

      expect(find.text('Search Vaani'), findsOneWidget);
      await tester.tap(find.text('Scan invoice'));
      await tester.pumpAndSettle();

      expect(find.text('Invoice Scanner'), findsOneWidget);
    });

    testWidgets('inventory supports in-place stock update sheet', (
      tester,
    ) async {
      await pumpRoute(tester, '/inventory');

      expect(find.text('All Items'), findsOneWidget);
      expect(find.text('Low Stock'), findsOneWidget);
      expect(find.text('Out of Stock'), findsOneWidget);

      await tester.tap(find.text('Amul Milk 1L'));
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Update Stock'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('inventory add-product sheet inserts local item', (
      tester,
    ) async {
      await pumpRoute(tester, '/inventory');

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Product name'),
        'Parle-G Biscuits',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Category'),
        'Snacks',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Opening quantity'),
        '12',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Add product'));
      await tester.pumpAndSettle();

      expect(find.text('Parle-G Biscuits'), findsOneWidget);
      expect(find.text('12 pcs'), findsOneWidget);
    });

    testWidgets('scanner flow shows AI OCR review before inventory action', (
      tester,
    ) async {
      await pumpRoute(tester, '/ocr');

      expect(find.text('Invoice Scanner'), findsOneWidget);
      expect(find.text('Review Invoice'), findsOneWidget);
      expect(find.text('AI Review'), findsOneWidget);
      expect(find.text('Rice (Premium 25kg)'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Mustard Oil (1L)'),
        80,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text('Mustard Oil (1L)'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Add items'),
        80,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text('Add items'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Add items'));
      await tester.pumpAndSettle();

      expect(find.text('Queued'), findsOneWidget);
      expect(find.text('2 items queued for inventory'), findsOneWidget);
    });

    testWidgets(
        'sales screen exposes period, draft, export, and insight actions',
        (tester) async {
      await pumpRoute(tester, '/sales');

      expect(find.text('Sales Analytics'), findsOneWidget);
      expect(find.text('MONTH REVENUE'), findsOneWidget);
      expect(find.text('Rs 3,82,000'), findsOneWidget);

      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();
      expect(find.text('TODAY REVENUE'), findsOneWidget);
      expect(find.text('Rs 18,420'), findsOneWidget);

      await tester.tap(find.byTooltip('Export report'));
      await tester.pumpAndSettle();
      expect(find.text('Sales report export queued'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'New sale'));
      await tester.pumpAndSettle();
      expect(find.text('Record Sale'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Create draft'));
      await tester.pumpAndSettle();
      expect(find.text('Sale draft created'), findsOneWidget);

      await tester.drag(find.byType(Scrollable).first, const Offset(0, -360));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Basmati Rice'));
      await tester.pumpAndSettle();
      expect(find.text('Basmati Rice insight opened'), findsOneWidget);
    });

    testWidgets('payment reminders show udhaar insight and reminder actions', (
      tester,
    ) async {
      await pumpRoute(tester, '/payments');

      expect(find.text('Udhaar Reminders'), findsOneWidget);
      expect(find.text('TOTAL PENDING DUES'), findsOneWidget);
      expect(find.text('Rs 11,500'), findsOneWidget);
      expect(find.text('All Dues (3)'), findsOneWidget);
      expect(find.text('Rajesh Kumar'), findsOneWidget);
      expect(find.text('Remind'), findsWidgets);

      await tester.drag(find.byType(Scrollable).first, const Offset(0, -320));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Remind').first);
      await tester.pumpAndSettle();

      expect(find.text('REMINDED'), findsOneWidget);
    });

    testWidgets('login workspace entry opens home dashboard', (tester) async {
      await pumpRoute(tester, '/login');

      expect(find.text('Welcome back'), findsOneWidget);
      await tester.tap(find.text('Open business workspace'));
      await tester.pumpAndSettle();

      expect(find.text('TODAY SALES'), findsOneWidget);
    });

    testWidgets('voice screen toggles commands and opens language selector', (
      tester,
    ) async {
      await pumpRoute(tester, '/voice');

      expect(find.text('Listening'), findsOneWidget);
      await tester.tap(find.text('Low stock items'));
      await tester.pump(const Duration(milliseconds: 450));
      expect(find.text('Thinking'), findsOneWidget);
      expect(find.text('Command selected: Low stock items'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Stop'));
      await tester.pump(const Duration(milliseconds: 450));
      expect(find.text('Listening'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.language_rounded));
      await tester.pump(const Duration(milliseconds: 450));
      expect(find.text('Voice Language'), findsOneWidget);
      expect(find.text('Tamil'), findsWidgets);
    });

    testWidgets('settings exposes localization and voice preferences', (
      tester,
    ) async {
      await pumpRoute(tester, '/settings');

      expect(find.text('Settings'), findsWidgets);
      expect(find.text('App Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Hindi'), findsWidgets);
      expect(find.text('Voice Assistant'), findsOneWidget);
      expect(find.text('Voice Feedback'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets('onboarding is a carousel before entering the app', (
      tester,
    ) async {
      await pumpRoute(tester, '/onboarding');

      expect(
        find.textContaining('Manage Business', findRichText: true),
        findsOneWidget,
      );
      expect(find.textContaining('Voice', findRichText: true), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Get Started'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        find.textContaining('Scan Invoices', findRichText: true),
        findsOneWidget,
      );
      expect(find.textContaining('AI OCR', findRichText: true), findsOneWidget);
    });

    testWidgets('primary screens fit compact mobile viewport', (tester) async {
      const routes = [
        '/home',
        '/inventory',
        '/sales',
        '/voice',
        '/ocr',
        '/payments',
        '/settings',
        '/login',
        '/onboarding',
      ];

      for (final route in routes) {
        await pumpRoute(tester, route, viewport: const Size(360, 700));
        await tester.pump(const Duration(milliseconds: 350));
        expect(tester.takeException(), isNull, reason: '$route overflowed');
      }
    });
  });
}
