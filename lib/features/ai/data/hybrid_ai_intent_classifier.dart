import '../domain/ai_client.dart';
import '../domain/assistant_intent.dart';

class HybridAiIntentClassifier {
  const HybridAiIntentClassifier(this._client);

  final AiClient _client;

  Future<AssistantIntent> classify({
    required String utterance,
    required String locale,
    Map<String, Object?> businessContext = const {},
  }) async {
    final normalized = utterance.trim().toLowerCase();
    final localIntent = _fastPath(normalized);
    if (localIntent != null) return localIntent;

    final response = await _client.classifyIntent(
      utterance: utterance,
      locale: locale,
      businessContext: businessContext,
    );
    return _fromToolCall(response, utterance);
  }

  AssistantIntent? _fastPath(String text) {
    if (text.contains('low') || text.contains('running low')) {
      return const LowStockIntent();
    }
    if (text.contains('sales today') || text.contains('aaj ki sales')) {
      return const SalesTodayIntent();
    }
    if (text.contains('pending payment')) {
      return const PendingPaymentsIntent();
    }
    return null;
  }

  AssistantIntent _fromToolCall(
    Map<String, Object?> json,
    String originalText,
  ) {
    switch (json['intent']) {
      case 'add_inventory':
        return AddInventoryIntent(
          productName: json['productName']! as String,
          quantity: (json['quantity']! as num).toDouble(),
          unit: json['unit']! as String,
        );
      case 'sales_today':
        return const SalesTodayIntent();
      case 'low_stock':
        return const LowStockIntent();
      case 'pending_payments':
        return const PendingPaymentsIntent();
      default:
        return UnknownIntent(originalText);
    }
  }
}
