import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/custom_intent_model.dart';
import '../data/hybrid_ai_intent_classifier.dart';
import '../data/melange_ai_client.dart';

final melangeAiClientProvider = Provider<MelangeAiClient>(
  (ref) => const MelangeAiClient(),
);

final melangeReadyProvider = FutureProvider<bool>((ref) async {
  return ref.watch(melangeAiClientProvider).isReady();
});

final melangeModelsProvider =
    FutureProvider<Map<String, Object?>>((ref) async {
  return ref.watch(melangeAiClientProvider).describeModels();
});

final customIntentModelProvider = FutureProvider<CustomIntentModel>((ref) async {
  return CustomIntentModel.load();
});

final melangeClassifierProvider =
    FutureProvider<HybridAiIntentClassifier>((ref) async {
  final client = ref.watch(melangeAiClientProvider);
  final customModel = await ref.watch(customIntentModelProvider.future);
  return HybridAiIntentClassifier(client, Future.value(customModel));
});
