import 'product.dart';

abstract interface class InventoryRepository {
  Stream<List<Product>> watchProducts(String businessId);
  Future<Product?> findByName(String businessId, String name);
  Future<void> upsert(Product product);
  Future<void> adjustQuantity({
    required String businessId,
    required String productId,
    required double delta,
  });
  Future<List<Product>> lowStockProducts(String businessId);
}
