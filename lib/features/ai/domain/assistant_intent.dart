sealed class AssistantIntent {
  const AssistantIntent();
}

final class AddInventoryIntent extends AssistantIntent {
  const AddInventoryIntent({
    required this.productName,
    required this.quantity,
    required this.unit,
  });

  final String productName;
  final double quantity;
  final String unit;
}

final class SalesTodayIntent extends AssistantIntent {
  const SalesTodayIntent();
}

final class LowStockIntent extends AssistantIntent {
  const LowStockIntent();
}

final class PendingPaymentsIntent extends AssistantIntent {
  const PendingPaymentsIntent();
}

final class UnknownIntent extends AssistantIntent {
  const UnknownIntent(this.originalText);

  final String originalText;
}
