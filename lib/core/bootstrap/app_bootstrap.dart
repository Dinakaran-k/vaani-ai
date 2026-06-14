import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final appBootstrapProvider = Provider<AppBootstrap>((ref) => AppBootstrap());

class AppBootstrap {
  Future<void> initialize() async {
    await Hive.initFlutter();
    if (!kIsWeb) {
      await _initializeFirebaseSafely();
    }
  }

  Future<void> _initializeFirebaseSafely() async {
    try {
      await Firebase.initializeApp();
    } on Object {
      // Allows local development before firebase_options.dart is generated.
      // CI should run with configured Firebase options for release builds.
    }
  }
}
