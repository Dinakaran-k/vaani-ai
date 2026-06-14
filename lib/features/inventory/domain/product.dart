class Product {
  const Product({
    required this.id,
    required this.businessId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.lowStockThreshold,
    required this.updatedAt,
    this.barcode,
    this.gstRate,
    this.sellingPrice,
  });

  final String id;
  final String businessId;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final double lowStockThreshold;
  final DateTime updatedAt;
  final String? barcode;
  final double? gstRate;
  final double? sellingPrice;

  bool get isLowStock => quantity <= lowStockThreshold;

  Product copyWith({
    String? id,
    String? businessId,
    String? name,
    String? category,
    double? quantity,
    String? unit,
    double? lowStockThreshold,
    DateTime? updatedAt,
    String? barcode,
    double? gstRate,
    double? sellingPrice,
  }) {
    return Product(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      updatedAt: updatedAt ?? this.updatedAt,
      barcode: barcode ?? this.barcode,
      gstRate: gstRate ?? this.gstRate,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'businessId': businessId,
        'name': name,
        'category': category,
        'quantity': quantity,
        'unit': unit,
        'lowStockThreshold': lowStockThreshold,
        'updatedAt': updatedAt.toIso8601String(),
        'barcode': barcode,
        'gstRate': gstRate,
        'sellingPrice': sellingPrice,
      };

  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: json['id']! as String,
      businessId: json['businessId']! as String,
      name: json['name']! as String,
      category: json['category']! as String,
      quantity: (json['quantity']! as num).toDouble(),
      unit: json['unit']! as String,
      lowStockThreshold: (json['lowStockThreshold']! as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt']! as String),
      barcode: json['barcode'] as String?,
      gstRate: (json['gstRate'] as num?)?.toDouble(),
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
    );
  }
}
