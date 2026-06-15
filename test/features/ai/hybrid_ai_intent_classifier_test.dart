import 'package:flutter_test/flutter_test.dart';
import 'package:vaani_ai/features/ai/data/hybrid_ai_intent_classifier.dart';
import 'package:vaani_ai/features/ai/domain/ai_client.dart';
import 'package:vaani_ai/features/ai/domain/assistant_intent.dart';

class _FakeAiClient implements AiClient {
  _FakeAiClient([this.response]);

  final Map<String, Object?>? response;

  @override
  Future<Map<String, Object?>> classifyIntent({
    required String utterance,
    required String locale,
    required Map<String, Object?> businessContext,
  }) async {
    return response ??
        {
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

  test('falls back to unknown intent for unsupported AI tool call', () async {
    final classifier = HybridAiIntentClassifier(
      _FakeAiClient({'intent': 'unsupported'}),
    );

    final intent = await classifier.classify(
      utterance: 'Do something unusual',
      locale: 'en-IN',
    );

    expect(intent, isA<UnknownIntent>());
    expect((intent as UnknownIntent).originalText, 'Do something unusual');
  });
}
