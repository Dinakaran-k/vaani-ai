import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/ai_client.dart';

class GeminiAiClient implements AiClient {
  GeminiAiClient({
    required Dio dio,
    required String endpoint,
    required String apiKey,
  })  : _dio = dio,
        _endpoint = endpoint,
        _apiKey = apiKey;

  final Dio _dio;
  final String _endpoint;
  final String _apiKey;

  @override
  Future<Map<String, Object?>> classifyIntent({
    required String utterance,
    required String locale,
    required Map<String, Object?> businessContext,
  }) async {
    try {
      final response = await _dio.post<Map<String, Object?>>(
        _endpoint,
        options: Options(headers: {'x-api-key': _apiKey}),
        data: {
          'provider': 'gemini',
          'locale': locale,
          'utterance': utterance,
          'businessContext': businessContext,
          'schema': _intentSchema,
        },
      );
      return _requireObject(response.data);
    } on DioException catch (error) {
      throw AiException('Gemini intent classification failed', cause: error);
    }
  }
}

class OpenAiIntentClient implements AiClient {
  OpenAiIntentClient({
    required Dio dio,
    required String endpoint,
    required String apiKey,
  })  : _dio = dio,
        _endpoint = endpoint,
        _apiKey = apiKey;

  final Dio _dio;
  final String _endpoint;
  final String _apiKey;

  @override
  Future<Map<String, Object?>> classifyIntent({
    required String utterance,
    required String locale,
    required Map<String, Object?> businessContext,
  }) async {
    try {
      final response = await _dio.post<Map<String, Object?>>(
        _endpoint,
        options: Options(headers: {'x-api-key': _apiKey}),
        data: {
          'provider': 'openai',
          'locale': locale,
          'utterance': utterance,
          'businessContext': businessContext,
          'schema': _intentSchema,
        },
      );
      return _requireObject(response.data);
    } on DioException catch (error) {
      throw AiException('OpenAI intent classification failed', cause: error);
    }
  }
}

Map<String, Object?> _requireObject(Map<String, Object?>? data) {
  if (data == null || data['intent'] is! String) {
    throw const AiException('AI response did not match the intent schema');
  }
  return data;
}

const _intentSchema = {
  'type': 'object',
  'required': ['intent'],
  'properties': {
    'intent': {
      'enum': [
        'add_inventory',
        'sales_today',
        'low_stock',
        'pending_payments',
      ],
    },
    'productName': {'type': 'string'},
    'quantity': {'type': 'number'},
    'unit': {'type': 'string'},
  },
};
