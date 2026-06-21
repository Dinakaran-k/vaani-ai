import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../features/ai/application/melange_providers.dart';
import '../../../shared/presentation/vaani_shell.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  var _selectedLanguage = 'English';
  var _voiceFeedback = true;
  var _heyVaani = false;
  var _speechSpeed = 'normal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          children: [
            Text('Settings', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 6),
            Text(
              'Manage your account and preferences',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: VaaniTheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            VaaniCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rajesh Kumar',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        const Text('Kumar Provisions - +91 98765 43210'),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: _showProfileSheet,
                    icon: const Icon(Icons.edit_rounded),
                  ),
                ],
              ),
            ),
            const _SectionHeader(
              icon: Icons.language_rounded,
              title: 'App Language',
            ),
            const SizedBox(height: 14),
            _LanguageGrid(
              selectedLanguage: _selectedLanguage,
              onSelected: (language) {
                setState(() => _selectedLanguage = language);
                showVaaniSnackBar(context, '$language selected');
              },
            ),
            const SizedBox(height: 28),
            const _SectionHeader(
              icon: Icons.mic_rounded,
              title: 'Voice Assistant',
            ),
            const SizedBox(height: 14),
            VaaniCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    value: _voiceFeedback,
                    onChanged: (value) =>
                        setState(() => _voiceFeedback = value),
                    title: const Text('Voice Feedback'),
                    subtitle: const Text('Vaani reads out amounts and actions'),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Speed of Speech',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'slow', label: Text('Slow')),
                            ButtonSegment(
                              value: 'normal',
                              label: Text('Normal'),
                            ),
                            ButtonSegment(value: 'fast', label: Text('Fast')),
                          ],
                          selected: {_speechSpeed},
                          onSelectionChanged: (value) {
                            setState(() => _speechSpeed = value.single);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _heyVaani,
                    onChanged: (value) => setState(() => _heyVaani = value),
                    title: const Text('"Hey Vaani" Detection'),
                    subtitle: const Text('Activate assistant without tapping'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const _SectionHeader(
              icon: Icons.memory_rounded,
              title: 'Melange Models',
            ),
            const SizedBox(height: 14),
            FutureBuilder<Map<String, Object?>>(
              future: ref.watch(melangeModelsProvider.future),
              builder: (context, snapshot) {
                final data = snapshot.data ?? const {};
                return VaaniCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Voice intent model'),
                        subtitle: Text(
                          data['voiceIntentModel'] as String? ??
                              'google/gemma-3n-E2B-it',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Invoice model'),
                        subtitle: Text(
                          data['invoiceModel'] as String? ?? 'Menlo/Jan-nano',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Whisper encoder'),
                        subtitle: Text(
                          data['asrEncoderModel'] as String? ??
                              'vaibhav-zetic/whisper_small_encoder',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Whisper decoder'),
                        subtitle: Text(
                          data['asrDecoderModel'] as String? ??
                              'OpenAI/whisper-tiny-decoder',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Legacy speech model'),
                        subtitle: Text(
                          data['asrModel'] as String? ??
                              'vaibhav-zetic/whisper_small_encoder',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Language model'),
                        subtitle: Text(
                          data['languageModel'] as String? ??
                              'SentenceTransformers/nli-MiniLM2-L6-H768',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Inventory model'),
                        subtitle: Text(
                          data['inventoryModel'] as String? ??
                              'Qwen/Qwen3-Reranker-0.6B',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Melange keeps the primary AI path on-device. The voice assistant uses the selected intent model, the scanner uses the invoice model, and Whisper is wired as an encoder/decoder pair for the future audio bridge.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: VaaniTheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 28),
            Text(
              'Help & Support',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            VaaniCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    onTap: _showTutorialSheet,
                    leading: const CircleAvatar(child: Icon(Icons.play_arrow)),
                    title: const Text('Watch Tutorial'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    onTap: _showSupportSheet,
                    leading:
                        const CircleAvatar(child: Icon(Icons.support_agent)),
                    title: const Text('Contact Support'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showProfileSheet() {
    final rootContext = context;
    final scheme = Theme.of(context).colorScheme;
    final ownerController = TextEditingController(text: 'Rajesh Kumar');
    final shopController = TextEditingController(text: 'Kumar Provisions');
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              8,
              24,
              28 + MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: ownerController,
                  decoration: const InputDecoration(
                    labelText: 'Owner name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: shopController,
                  decoration: const InputDecoration(
                    labelText: 'Business name',
                    prefixIcon: Icon(Icons.storefront_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    showVaaniSnackBar(rootContext, 'Profile saved locally');
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save profile'),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      ownerController.dispose();
      shopController.dispose();
    });
  }

  Future<void> _showTutorialSheet() {
    final scheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Tutorial',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                const _TutorialStep(
                  '1',
                  'Use Voice to update stock or ask for reports.',
                ),
                const _TutorialStep(
                  '2',
                  'Scan invoices, review extracted items, then add them.',
                ),
                const _TutorialStep(
                  '3',
                  'Track Udhaar and prepare reminders from Payments.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSupportSheet() {
    final rootContext = context;
    final scheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Support',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.chat_outlined)),
                  title: const Text('Start support chat'),
                  subtitle:
                      const Text('Usually replies within one business day'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    showVaaniSnackBar(rootContext, 'Support chat started');
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.mail_outline)),
                  title: const Text('Email support'),
                  subtitle: const Text('support@vaani.ai'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    showVaaniSnackBar(rootContext, 'Support email prepared');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TutorialStep extends StatelessWidget {
  const _TutorialStep(this.number, this.text);

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 15, child: Text(number)),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: scheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

class _LanguageGrid extends StatelessWidget {
  const _LanguageGrid({
    required this.selectedLanguage,
    required this.onSelected,
  });

  final String selectedLanguage;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const languages = [
      ('English', 'Default'),
      ('Hindi', 'Hindi'),
      ('Marathi', 'Marathi'),
      ('Gujarati', 'Gujarati'),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 920
            ? 4
            : constraints.maxWidth >= 620
                ? 3
                : 2;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisExtent: columns >= 3 ? 84 : 92,
          children: [
            for (final language in languages)
              _LanguageTile(
                title: language.$1,
                subtitle: language.$2,
                selected: language.$1 == selectedLanguage,
                onTap: () => onSelected(language.$1),
              ),
          ],
        );
      },
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color:
          selected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (selected) Icon(Icons.check_circle, color: scheme.primary),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: VaaniTheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
