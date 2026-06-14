import '../../../core/localization/supported_language.dart';

abstract interface class VoiceEngine {
  Future<bool> initialize();
  Future<String> listen({
    required SupportedLanguage language,
    Duration timeout,
  });
  Future<void> speak(String text, SupportedLanguage language);
  Future<void> stop();
}
