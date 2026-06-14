import 'package:flutter_test/flutter_test.dart';
import 'package:vaani_ai/features/inventory/domain/product.dart';

void main() {
  test('detects low stock', () {
    final product = Product(
      id: 'p1',
      businessId: 'b1',
      name: 'Rice',
      category: 'Grains',
      quantity: 4,
      unit: 'bags',
      lowStockThreshold: 5,
      updatedAt: DateTime.utc(2026),
    );

    expect(product.isLowStock, isTrue);
  });
}
