import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_motion.dart';

Future<void> showVoiceAssistantSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.64),
    builder: (sheetContext) => const _VoiceAssistantSheet(),
  );
}

class _VoiceAssistantSheet extends StatefulWidget {
  const _VoiceAssistantSheet();

  @override
  State<_VoiceAssistantSheet> createState() => _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends State<_VoiceAssistantSheet> {
  var _listening = true;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.82,
        minChildSize: 0.66,
        maxChildSize: 0.96,
        builder: (context, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: VaaniTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
              children: [
                Center(
                  child: Container(
                    width: 58,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7C4D7),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _listening
                              ? VaaniTheme.primary
                              : VaaniTheme.secondary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton.filledTonal(
                      onPressed: () {},
                      icon: const Icon(Icons.language_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                AnimatedAiGlow(
                  size: 220,
                  glowColor:
                      _listening ? VaaniTheme.primary : VaaniTheme.secondary,
                  child: const AnimatedVaaniWaveform(
                    barCount: 7,
                    width: 12,
                    minHeight: 24,
                    maxHeight: 104,
                    spacing: 4,
                  ),
                ),
                const SizedBox(height: 32),
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
                        color: VaaniTheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _SuggestionChip('Add 20 bags rice'),
                    _SuggestionChip('Show sales today'),
                    _SuggestionChip('Pending payments'),
                    _SuggestionChip('Low stock items'),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => setState(() => _listening = !_listening),
                  icon: Icon(_listening ? Icons.mic_rounded : Icons.stop),
                  label: Text(_listening ? 'Hold to speak' : 'Stop'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFC7C4D7)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
