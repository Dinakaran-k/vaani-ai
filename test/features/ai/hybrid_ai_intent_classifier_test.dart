import 'package:flutter_test/flutter_test.dart';
import 'package:vaani_ai/features/ai/data/custom_intent_model.dart';
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

class _FailingAiClient implements AiClient {
  @override
  Future<Map<String, Object?>> classifyIntent({
    required String utterance,
    required String locale,
    required Map<String, Object?> businessContext,
  }) async {
    fail('Melange fallback should not run when the custom model resolves');
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

  test('uses deterministic shortcut for add inventory phrasing', () async {
    final classifier = HybridAiIntentClassifier(_FakeAiClient());

    final intent = await classifier.classify(
      utterance: 'Add 12 bags of rice',
      locale: 'en-IN',
    );

    expect(intent, isA<AddInventoryIntent>());
    expect((intent as AddInventoryIntent).productName, 'rice');
    expect(intent.quantity, 12);
    expect(intent.unit, 'bags');
  });

  test('uses deterministic shortcut for pending dues phrasing', () async {
    final classifier = HybridAiIntentClassifier(_FakeAiClient());

    final intent = await classifier.classify(
      utterance: 'Show pending udhaar',
      locale: 'en-IN',
    );

    expect(intent, isA<PendingPaymentsIntent>());
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

  test('falls back to unknown intent when add inventory slots are missing',
      () async {
    final classifier = HybridAiIntentClassifier(
      _FakeAiClient({'intent': 'add_inventory'}),
    );

    final intent = await classifier.classify(
      utterance: 'Add stock',
      locale: 'en-IN',
    );

    expect(intent, isA<UnknownIntent>());
    expect((intent as UnknownIntent).originalText, 'Add stock');
  });

  test('uses the custom on-device model before Melange fallback', () async {
    final customModel = CustomIntentModel.fromJson({
      'version': 1,
      'algorithm': 'multinomial_naive_bayes',
      'alpha': 1.0,
      'vocabSize': 6,
      'labelCount': 4,
      'classes': {
        'add_inventory': {
          'prior': 0.25,
          'totalTokens': 8,
          'tokenCounts': {
            'add': 2,
            'bags': 1,
            'rice': 2,
            'num_20': 1,
            'stock': 1,
            'restock': 1,
          },
        },
        'sales_today': {
          'prior': 0.25,
          'totalTokens': 6,
          'tokenCounts': {
            'sales': 2,
            'today': 2,
            'revenue': 1,
            'report': 1,
          },
        },
        'low_stock': {
          'prior': 0.25,
          'totalTokens': 6,
          'tokenCounts': {
            'low': 2,
            'stock': 2,
            'inventory': 1,
            'items': 1,
          },
        },
        'pending_payments': {
          'prior': 0.25,
          'totalTokens': 6,
          'tokenCounts': {
            'pending': 2,
            'payments': 2,
            'dues': 1,
            'udhaar': 1,
          },
        },
      },
    });

    final classifier = HybridAiIntentClassifier(
      _FailingAiClient(),
      Future.value(customModel),
    );

    final intent = await classifier.classify(
      utterance: 'Show low stock items',
      locale: 'en-IN',
    );

    expect(intent, isA<LowStockIntent>());
  });
}
