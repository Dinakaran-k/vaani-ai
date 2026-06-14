class InvoiceOcrResult {
  const InvoiceOcrResult({
    required this.rawText,
    required this.vendorName,
    required this.gstin,
    required this.items,
  });

  final String rawText;
  final String? vendorName;
  final String? gstin;
  final List<InvoiceLineItem> items;
}

class InvoiceLineItem {
  const InvoiceLineItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.gstRate,
  });

  final String name;
  final double quantity;
  final double unitPrice;
  final double? gstRate;
}
