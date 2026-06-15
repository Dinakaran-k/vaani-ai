import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaani_ai/app/router.dart';
import 'package:vaani_ai/app/theme.dart';

void main() {
  testWidgets('bottom navigation preserves tab state', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider)..go('/home');

    await tester.pumpWidget(
      MaterialApp.router(
        theme: VaaniTheme.light(),
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Stock'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'milk');
    await tester.pumpAndSettle();
    expect(find.text('Amul Milk 1L'), findsOneWidget);
    expect(find.text('Basmati Rice'), findsNothing);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('TODAY SALES'), findsOneWidget);

    await tester.tap(find.text('Stock'));
    await tester.pumpAndSettle();
    expect(find.text('Amul Milk 1L'), findsOneWidget);
    expect(find.text('Basmati Rice'), findsNothing);
  });
}
