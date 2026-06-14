import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/inventory_repository.dart';
import '../domain/product.dart';

class FirestoreInventoryRepository implements InventoryRepository {
  FirestoreInventoryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _products(String businessId) {
    return _firestore
        .collection('businesses')
        .doc(businessId)
        .collection('products');
  }

  @override
  Stream<List<Product>> watchProducts(String businessId) {
    return _products(businessId).orderBy('name').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            return Product.fromJson({...doc.data(), 'id': doc.id});
          }).toList(),
        );
  }

  @override
  Future<Product?> findByName(String businessId, String name) async {
    final query = await _products(businessId)
        .where('searchName', isEqualTo: name.trim().toLowerCase())
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    final doc = query.docs.first;
    return Product.fromJson({...doc.data(), 'id': doc.id});
  }

  @override
  Future<void> upsert(Product product) {
    return _products(product.businessId).doc(product.id).set(
      {
        ...product.toJson(),
        'searchName': product.name.trim().toLowerCase(),
        'updatedAt': product.updatedAt.toIso8601String(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> adjustQuantity({
    required String businessId,
    required String productId,
    required double delta,
  }) {
    return _products(businessId).doc(productId).update({
      'quantity': FieldValue.increment(delta),
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Future<List<Product>> lowStockProducts(String businessId) async {
    final snapshot = await _products(businessId).get();
    return snapshot.docs
        .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
        .where((product) => product.isLowStock)
        .toList();
  }
}
