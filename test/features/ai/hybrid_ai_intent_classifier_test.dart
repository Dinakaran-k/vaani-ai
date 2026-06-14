import 'package:flutter_test/flutter_test.dart';
import 'package:vaani_ai/features/ai/data/hybrid_ai_intent_classifier.dart';
import 'package:vaani_ai/features/ai/domain/ai_client.dart';
import 'package:vaani_ai/features/ai/domain/assistant_intent.dart';

class _FakeAiClient implements AiClient {
  @override
  Future<Map<String, Object?>> classifyIntent({
    required String utterance,
    required String locale,
    required Map<String, Object?> businessContext,
  }) async {
    return {
      'intent': 'add_inventory',
      'productName': 'rice',
      'quantity': 20,
      'unit': 'bags',
    };
  }
}

void main() {
  test('uses deterministic shortcut for low stock', () async {
    final classifier = HybridAiIntentClassifier(_FakeAiClient());

    final intent = await classifier.classify(
      utterance: 'Which products are running low?',
      locale: 'en-IN',
    );

    expect(intent, isA<LowStockIntent>());
  });

  test('maps AI tool call into add inventory intent', () async {
    final classifier = HybridAiIntentClassifier(_FakeAiClient());

    final intent = await classifier.classify(
      utterance: 'Add 20 bags of rice',
      locale: 'en-IN',
    );

    expect(intent, isA<AddInventoryIntent>());
    expect((intent as AddInventoryIntent).quantity, 20);
  });
}
