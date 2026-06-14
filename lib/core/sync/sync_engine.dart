import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'sync_operation.dart';

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(
    firestore: FirebaseFirestore.instance,
    connectivity: Connectivity(),
  );
});

class SyncEngine {
  SyncEngine({
    required FirebaseFirestore firestore,
    required Connectivity connectivity,
  })  : _firestore = firestore,
        _connectivity = connectivity;

  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  Future<Box<Map<dynamic, dynamic>>> _box() {
    return Hive.openBox<Map<dynamic, dynamic>>('sync_queue');
  }

  Future<void> enqueue(SyncOperation operation) async {
    final box = await _box();
    await box.put(operation.id, operation.toJson());
  }

  Future<int> flush() async {
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      return 0;
    }

    final box = await _box();
    var flushed = 0;

    for (final key in box.keys.toList()) {
      final raw = box.get(key);
      if (raw == null) continue;
      final operation = SyncOperation.fromJson(
        raw.cast<String, Object?>(),
      );
      final ref =
          _firestore.collection(operation.collection).doc(operation.documentId);

      switch (operation.type) {
        case SyncOperationType.create:
        case SyncOperationType.update:
          await ref.set(operation.payload, SetOptions(merge: true));
        case SyncOperationType.delete:
          await ref.delete();
      }

      await box.delete(key);
      flushed++;
    }

    return flushed;
  }
}
