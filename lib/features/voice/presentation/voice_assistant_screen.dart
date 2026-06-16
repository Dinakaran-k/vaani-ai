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
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.82,
            colors: [Color(0xFFE1E0FF), VaaniTheme.surface],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 860;
              final glowSize = compact ? 148.0 : 196.0;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 44,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton.filledTonal(
                            onPressed: () => context.go('/home'),
                            icon: const Icon(Icons.close_rounded),
                          ),
                          Expanded(
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                child: Text(
                                  _listening ? 'Listening' : 'Thinking',
                                  key: ValueKey(_listening),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: _listening
                                        ? VaaniTheme.primary
                                        : VaaniTheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: () => showVaaniLanguageSheet(context),
                            icon: const Icon(Icons.language_rounded),
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 20 : 42),
                      AnimatedAiGlow(
                        size: glowSize,
                        glowColor: _listening
                            ? VaaniTheme.primary
                            : VaaniTheme.secondary,
                        child: const AnimatedVaaniWaveform(),
                      ),
                      SizedBox(height: compact ? 18 : 28),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: VaaniTheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: compact ? 20 : 42),
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
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: () =>
                            setState(() => _listening = !_listening),
                        icon: Icon(_listening ? Icons.mic_rounded : Icons.stop),
                        label: Text(_listening ? 'Hold to speak' : 'Stop'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _useSuggestion(String text) {
    setState(() => _listening = false);
    showVaaniSnackBar(context, 'Command selected: $text');
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip(this.text, {required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 132),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onPressed: onTap,
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFC7C4D7)),
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
