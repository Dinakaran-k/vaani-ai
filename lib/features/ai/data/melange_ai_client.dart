import 'package:flutter/services.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/ai_client.dart';
import 'melange_model_defaults.dart';

class MelangeAiClient implements AiClient {
  const MelangeAiClient([
    this._channel = const MethodChannel('vaani_ai/melange_ai'),
  ]);

  final MethodChannel _channel;

  Future<bool> isReady() async {
    try {
      final ready = await _channel.invokeMethod<bool>('isReady');
      return ready ?? false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<Map<String, Object?>> describeModels() async {
    try {
      final response = await _channel.invokeMapMethod<Object?, Object?>(
        'describeModels',
      );
      if (response == null || response.isEmpty) {
        return melangeModelDefaults;
      }

      return Map<String, Object?>.from(response);
    } on MissingPluginException {
      return melangeModelDefaults;
    } on PlatformException catch (error) {
      throw AiException('Melange model description failed', cause: error);
    }
  }

  @override
  Future<Map<String, Object?>> classifyIntent({
    required String utterance,
    required String locale,
    required Map<String, Object?> businessContext,
  }) async {
    try {
      final response = await _channel.invokeMapMethod<Object?, Object?>(
        'classifyIntent',
        {
          'utterance': utterance,
          'locale': locale,
          'businessContext': businessContext,
        },
      );
      if (response == null) {
        throw const AiException('Melange returned an empty response');
      }

      return Map<String, Object?>.from(response);
    } on MissingPluginException catch (error) {
      throw AiException(
        'Melange channel is not available on this build',
        cause: error,
      );
    } on PlatformException catch (error) {
      throw AiException('Melange intent classification failed', cause: error);
    }
  }

  Future<Map<String, Object?>> extractInvoice({
    required String ocrText,
    required String locale,
  }) async {
    try {
      final response = await _channel.invokeMapMethod<Object?, Object?>(
        'extractInvoice',
        {
          'ocrText': ocrText,
          'locale': locale,
        },
      );
      if (response == null) {
        throw const AiException('Melange returned an empty invoice response');
      }

      return Map<String, Object?>.from(response);
    } on MissingPluginException catch (error) {
      throw AiException(
        'Melange channel is not available on this build',
        cause: error,
      );
    } on PlatformException catch (error) {
      throw AiException('Melange invoice extraction failed', cause: error);
    }
  }
}
