class Sale {
  const Sale({
    required this.id,
    required this.businessId,
    required this.total,
    required this.currency,
    required this.createdAt,
    required this.items,
    this.customerName,
  });

  final String id;
  final String businessId;
  final double total;
  final String currency;
  final DateTime createdAt;
  final List<SaleItem> items;
  final String? customerName;

  Map<String, Object?> toJson() => {
        'id': id,
        'businessId': businessId,
        'total': total,
        'currency': currency,
        'createdAt': createdAt.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
        'customerName': customerName,
      };
}

class SaleItem {
  const SaleItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String name;
  final double quantity;
  final double unitPrice;

  double get subtotal => quantity * unitPrice;

  Map<String, Object?> toJson() => {
        'productId': productId,
        'name': name,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'subtotal': subtotal,
      };
}
