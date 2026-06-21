import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaani_ai/features/ai/data/melange_ai_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('vaani_ai/melange_ai');

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('reads readiness from the Melange bridge', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'isReady') {
        return true;
      }
      return null;
    });

    final client = MelangeAiClient(channel);

    expect(await client.isReady(), isTrue);
  });

  test('describes task models from the Melange bridge', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'describeModels') {
        return {
          'voiceIntentModel': 'google/gemma-3n-E2B-it',
          'invoiceModel': 'Menlo/Jan-nano',
          'asrEncoderModel': 'vaibhav-zetic/whisper_small_encoder',
          'asrDecoderModel': 'OpenAI/whisper-tiny-decoder',
          'ready': true,
        };
      }
      return null;
    });

    final client = MelangeAiClient(channel);
    final response = await client.describeModels();

    expect(response['voiceIntentModel'], 'google/gemma-3n-E2B-it');
    expect(response['invoiceModel'], 'Menlo/Jan-nano');
    expect(response['asrEncoderModel'], 'vaibhav-zetic/whisper_small_encoder');
    expect(response['asrDecoderModel'], 'OpenAI/whisper-tiny-decoder');
  });

  test('forwards classify intent to the Melange bridge', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'classifyIntent') {
        return {
          'intent': 'sales_today',
        };
      }
      if (call.method == 'isReady') {
        return true;
      }
      return null;
    });

    final client = MelangeAiClient(channel);
    final response = await client.classifyIntent(
      utterance: 'Show sales today',
      locale: 'en-IN',
      businessContext: const {},
    );

    expect(response['intent'], 'sales_today');
  });

  test('forwards invoice extraction to the Melange bridge', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'extractInvoice') {
        return {
          'vendorName': 'Vaani Super Mart',
          'totalAmount': 12450,
          'items': [
            {
              'name': 'Rice Premium 25kg',
              'quantity': 10,
              'unit': 'bags',
              'price': 8500,
            },
          ],
        };
      }
      if (call.method == 'isReady') {
        return true;
      }
      return null;
    });

    final client = MelangeAiClient(channel);
    final response = await client.extractInvoice(
      ocrText: 'sample invoice text',
      locale: 'en-IN',
    );

    expect(response['vendorName'], 'Vaani Super Mart');
    expect(response['items'], isA<List>());
  });
}
