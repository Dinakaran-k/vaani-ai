import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class VoiceAssistantScreen extends StatelessWidget {
  const VoiceAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.82,
            colors: [Color(0xFFE1E0FF), VaaniTheme.surface],
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
                    const Text(
                      'Listening',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: VaaniTheme.primary,
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
                Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: VaaniTheme.primary.withValues(alpha: 0.08),
                    boxShadow: [
                      BoxShadow(
                        color: VaaniTheme.primary.withValues(alpha: 0.18),
                        blurRadius: 70,
                        spreadRadius: 26,
                      ),
                    ],
                  ),
                  child: const Center(child: _LargeWaveform()),
                ),
                const SizedBox(height: 48),
                Text(
                  'How can I help your shop?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Speak naturally in Hindi, English, Hinglish, Tamil, Telugu, Gujarati, Marathi, and more.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: VaaniTheme.onSurfaceVariant,
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
                  onPressed: () {},
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text('Hold to speak'),
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

class _LargeWaveform extends StatelessWidget {
  const _LargeWaveform();

  @override
  Widget build(BuildContext context) {
    const heights = [26.0, 68.0, 110.0, 76.0, 42.0, 90.0, 52.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final height in heights)
          Container(
            width: 14,
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              gradient: VaaniTheme.aiGradient,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
      ],
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
