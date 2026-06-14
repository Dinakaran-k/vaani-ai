import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/vaani_app.dart';
import 'core/bootstrap/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(appBootstrapProvider).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const VaaniApp(),
    ),
  );
}
