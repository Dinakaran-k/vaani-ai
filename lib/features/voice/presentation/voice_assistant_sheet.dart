import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../features/ai/application/melange_providers.dart';
import '../../../core/localization/supported_language.dart';
import '../../../features/ai/data/hybrid_ai_intent_classifier.dart';
import '../../../features/ai/domain/assistant_intent.dart';
import '../../../features/voice/data/device_voice_engine.dart';
import '../../../features/voice/domain/voice_engine.dart';
import '../../../shared/presentation/vaani_motion.dart';
import '../../../shared/presentation/vaani_shell.dart';

Future<void> showVoiceAssistantSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    sheetAnimationStyle: AnimationStyle.noAnimation,
    backgroundColor: Colors.transparent,
    barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.64),
    builder: (sheetContext) => const _VoiceAssistantSheet(),
  );
}

class _VoiceAssistantSheet extends ConsumerStatefulWidget {
  const _VoiceAssistantSheet();

  @override
  ConsumerState<_VoiceAssistantSheet> createState() =>
      _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends ConsumerState<_VoiceAssistantSheet> {
  late final VoiceEngine _voiceEngine = DeviceVoiceEngine(
    speech: SpeechToText(),
    tts: FlutterTts(),
  );
  late final Future<bool> _voiceReady = _voiceEngine.initialize();
  late final Future<HybridAiIntentClassifier> _classifierFuture;
  var _language = SupportedLanguage.english;
  var _listening = true;
  var _latestIntentSummary =
      'Tap a suggestion to try the local on-device fast path.';

  @override
  void initState() {
    super.initState();
    _classifierFuture = ref.read(melangeClassifierProvider.future);
  }

  @override
  void dispose() {
    _voiceEngine.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            children: [
              Center(
                child: Container(
                  width: 58,
                  height: 6,
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Text(
                      _listening ? 'Listening' : 'Thinking',
                      key: ValueKey(_listening),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color:
                                _listening ? scheme.primary : scheme.secondary,
                          ),
                    ),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: () async {
                      final selected = await showVaaniLanguageSheet(
                        context,
                        selectedLanguage: _language,
                      );
                      if (!mounted || selected == null) return;
                      setState(() => _language = selected);
                    },
                    icon: const Icon(Icons.language_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AnimatedAiGlow(
                size: 190,
                glowColor: _listening ? scheme.primary : scheme.secondary,
                child: const AnimatedVaaniWaveform(
                  barCount: 7,
                  width: 12,
                  minHeight: 24,
                  maxHeight: 104,
                  spacing: 4,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                _listening
                    ? 'How can I help your shop?'
                    : 'Finding the right action...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                _listening
                    ? 'Speak naturally in Hindi, English, Hinglish, Tamil, Telugu, Gujarati, Marathi, and more.'
                    : 'Vaani validates your command before changing business data.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                _latestIntentSummary,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<bool>(
                future: ref.watch(melangeReadyProvider.future),
                builder: (context, snapshot) {
                  final ready = snapshot.data == true;
                  final label =
                      snapshot.connectionState == ConnectionState.waiting
                          ? 'Checking Melange bridge...'
                          : ready
                              ? 'Melange bridge ready for on-device inference.'
                              : 'Melange bridge not connected yet.';

                  return Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ready
                              ? scheme.secondary
                              : scheme.onSurfaceVariant,
                        ),
                  );
                },
              ),
              const SizedBox(height: 6),
              FutureBuilder<Map<String, Object?>>(
                future: ref.watch(melangeModelsProvider.future),
                builder: (context, snapshot) {
                  final data = snapshot.data ?? const {};
                  final voiceModel =
                      data['voiceIntentModel'] as String? ?? 'unknown';
                  final invoiceModel =
                      data['invoiceModel'] as String? ?? 'unknown';
                  final asrEncoderModel =
                      data['asrEncoderModel'] as String? ?? 'unknown';
                  final asrDecoderModel =
                      data['asrDecoderModel'] as String? ?? 'unknown';
                  return Text(
                    'Voice model: $voiceModel | Invoice model: $invoiceModel | Whisper encoder: $asrEncoderModel | Whisper decoder: $asrDecoderModel',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  );
                },
              ),
              const SizedBox(height: 6),
              FutureBuilder<bool>(
                future: _voiceReady,
                builder: (context, snapshot) {
                  final ready = snapshot.data == true;
                  return Text(
                    ready
                        ? 'Voice input ready: ${_language.label}'
                        : 'Preparing voice input...',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  );
                },
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _listening
                    ? _startListening
                    : () => setState(() => _listening = true),
                icon: Icon(_listening ? Icons.mic_rounded : Icons.stop),
                label: Text(_listening ? 'Hold to speak' : 'Stop'),
              ),
              const SizedBox(height: 14),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  _SuggestionChip(
                    'Add 20 bags rice',
                    onTap: () => _useSuggestion('Add 20 bags rice'),
                  ),
                  _SuggestionChip(
                    'Show sales today',
                    onTap: () => _useSuggestion('Show sales today'),
                  ),
                  _SuggestionChip(
                    'Pending payments',
                    onTap: () => _useSuggestion('Pending payments'),
                  ),
                  _SuggestionChip(
                    'Low stock items',
                    onTap: () => _useSuggestion('Low stock items'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _useSuggestion(String text) async {
    setState(() => _listening = false);
    try {
      await _classifySuggestion(text);
      if (!mounted) return;
      showVaaniSnackBar(context, 'Command selected: $text');
    } finally {
      if (mounted) {
        setState(() => _listening = true);
      }
    }
  }

  Future<void> _startListening() async {
    setState(() {
      _listening = false;
      _latestIntentSummary = 'Listening on-device...';
    });

    try {
      final transcript = await _voiceEngine.listen(
        language: _language,
        timeout: const Duration(seconds: 6),
      );
      if (!mounted) return;
      if (transcript.isEmpty) {
        setState(() {
          _latestIntentSummary = 'No speech detected. Try again.';
          _listening = true;
        });
        return;
      }

      final classifier = await _classifierFuture;
      final intent = await classifier.classify(
        utterance: transcript,
        locale: _language.speechLocale,
      );
      if (!mounted) return;

      final summary = switch (intent) {
        AddInventoryIntent(:final productName, :final quantity, :final unit) =>
          'Heard "$transcript" -> add $quantity $unit of $productName.',
        SalesTodayIntent() => 'Heard "$transcript" -> sales today.',
        LowStockIntent() => 'Heard "$transcript" -> low stock items.',
        PendingPaymentsIntent() => 'Heard "$transcript" -> pending payments.',
        UnknownIntent() => 'Heard "$transcript" but could not map it.',
      };
      setState(() {
        _latestIntentSummary = summary;
        _listening = true;
      });
      await _voiceEngine.speak(summary, _language);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _latestIntentSummary =
            'Voice input is unavailable right now. Try suggestion chips.';
        _listening = true;
      });
    }
  }

  Future<void> _classifySuggestion(String text) async {
    try {
      final classifier = await _classifierFuture;
      final intent = await classifier.classify(
        utterance: text,
        locale: 'en-IN',
      );
      if (!mounted) return;

      final summary = switch (intent) {
        AddInventoryIntent(:final productName, :final quantity, :final unit) =>
          'On-device AI recognized: add $quantity $unit of $productName.',
        SalesTodayIntent() => 'On-device AI recognized: sales today.',
        LowStockIntent() => 'On-device AI recognized: low stock items.',
        PendingPaymentsIntent() => 'On-device AI recognized: pending payments.',
        UnknownIntent() =>
          'On-device AI needs a remote fallback for this command.',
      };
      setState(() => _latestIntentSummary = summary);
      await _voiceEngine.speak(summary, _language);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _latestIntentSummary =
            'On-device AI is ready, and this command can fall back later.';
      });
    }
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip(this.text, {required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ActionChip(
      label: Text(text),
      onPressed: onTap,
      backgroundColor: scheme.surfaceContainerHighest,
      side: BorderSide(color: scheme.outlineVariant),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
