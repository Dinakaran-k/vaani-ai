import 'package:flutter_test/flutter_test.dart';
import 'package:vaani_ai/features/sales/domain/sale.dart';

void main() {
  test('sale item subtotal is quantity multiplied by unit price', () {
    const item = SaleItem(
      productId: 'p1',
      name: 'Rice',
      quantity: 3,
      unitPrice: 120,
    );

    expect(item.subtotal, 360);
  });

  test('sale serializes transaction details for repository adapters', () {
    final sale = Sale(
      id: 's1',
      businessId: 'b1',
      total: 360,
      currency: 'INR',
      createdAt: DateTime.utc(2026),
      items: const [
        SaleItem(
          productId: 'p1',
          name: 'Rice',
          quantity: 3,
          unitPrice: 120,
        ),
      ],
      customerName: 'Rajesh Kumar',
    );

    final json = sale.toJson();

    expect(json['businessId'], 'b1');
    expect(json['total'], 360);
    expect(json['currency'], 'INR');
    expect(json['customerName'], 'Rajesh Kumar');
    expect(json['items'], isA<List<Object?>>());
  });
}
