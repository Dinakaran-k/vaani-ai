import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_motion.dart';
import '../../../shared/presentation/vaani_shell.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  var _listening = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: _listening ? 0.82 : 1.0,
            colors: [
              _listening ? const Color(0xFFE1E0FF) : const Color(0xFFDDF7EF),
              VaaniTheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => context.go('/home'),
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
                const Spacer(),
                AnimatedAiGlow(
                  size: 244,
                  glowColor:
                      _listening ? VaaniTheme.primary : VaaniTheme.secondary,
                  child: const AnimatedVaaniWaveform(),
                ),
                const SizedBox(height: 48),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  child: Column(
                    key: ValueKey(_listening),
                    children: [
                      Text(
                        _listening
                            ? 'How can I help your shop?'
                            : 'Finding the right action...',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _listening
                            ? 'Speak naturally in Hindi, English, Hinglish, Tamil, Telugu, Gujarati, Marathi, and more.'
                            : 'Vaani validates your command before changing business data.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: VaaniTheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
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
          ),
        ),
      ),
      bottomNavigationBar: const VaaniBottomNav(current: 'voice'),
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
