import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/localization/supported_language.dart';
import '../domain/voice_engine.dart';

class DeviceVoiceEngine implements VoiceEngine {
  DeviceVoiceEngine({
    required SpeechToText speech,
    required FlutterTts tts,
  })  : _speech = speech,
        _tts = tts;

  final SpeechToText _speech;
  final FlutterTts _tts;

  @override
  Future<bool> initialize() => _speech.initialize();

  @override
  Future<String> listen({
    required SupportedLanguage language,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final ready = await _speech.initialize();
    if (!ready) return '';

    var recognized = '';
    await _speech.listen(
      listenOptions: SpeechListenOptions(
        localeId: language.speechLocale,
        listenFor: timeout,
        partialResults: false,
      ),
      onResult: (result) => recognized = result.recognizedWords,
    );
    await Future<void>.delayed(timeout);
    await _speech.stop();
    return recognized.trim();
  }

  @override
  Future<void> speak(String text, SupportedLanguage language) async {
    await _tts.setLanguage(language.speechLocale);
    await _tts.setSpeechRate(0.48);
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _speech.stop();
    await _tts.stop();
  }
}
