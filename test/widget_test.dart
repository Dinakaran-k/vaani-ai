import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaani_ai/app/theme.dart';
import 'package:vaani_ai/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  testWidgets('renders the Vaani dashboard shell', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: VaaniTheme.light(),
        home: const DashboardScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 650));

    expect(find.text('Vaani AI'), findsOneWidget);
    expect(find.text('TODAY SALES'), findsOneWidget);
    expect(find.text('Ask Vaani'), findsOneWidget);
  });
}
