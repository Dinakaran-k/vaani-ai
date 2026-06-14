import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firestore_inventory_repository.dart';
import '../domain/inventory_repository.dart';
import '../domain/product.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (_) => FirestoreInventoryRepository(FirebaseFirestore.instance),
);

final productsProvider =
    StreamProvider.family<List<Product>, String>((ref, businessId) {
  return ref.watch(inventoryRepositoryProvider).watchProducts(businessId);
});
