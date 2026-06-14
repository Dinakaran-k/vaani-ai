abstract interface class AiClient {
  Future<Map<String, Object?>> classifyIntent({
    required String utterance,
    required String locale,
    required Map<String, Object?> businessContext,
  });
}
