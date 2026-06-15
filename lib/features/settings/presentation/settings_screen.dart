import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rajesh Kumar',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text('Kumar Provisions - +91 98765 43210'),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const _SectionHeader(
              icon: Icons.language_rounded,
              title: 'App Language',
            ),
            const SizedBox(height: 14),
            const _LanguageGrid(),
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
                    value: true,
                    onChanged: (_) {},
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
                          selected: const {'normal'},
                          onSelectionChanged: (_) {},
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: false,
                    onChanged: (_) {},
                    title: const Text('"Hey Vaani" Detection'),
                    subtitle: const Text('Activate assistant without tapping'),
                  ),
                ],
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
                children: const [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.play_arrow)),
                    title: Text('Watch Tutorial'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.support_agent)),
                    title: Text('Contact Support'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const VaaniBottomNav(current: 'settings'),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: VaaniTheme.primary),
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
  const _LanguageGrid();

  @override
  Widget build(BuildContext context) {
    const languages = [
      ('English', 'Default', true),
      ('Hindi', 'Hindi', false),
      ('Marathi', 'Marathi', false),
      ('Gujarati', 'Gujarati', false),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 14) / 2;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            for (final language in languages)
              SizedBox(
                width: width,
                child: _LanguageTile(
                  title: language.$1,
                  subtitle: language.$2,
                  selected: language.$3,
                ),
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
  });

  final String title;
  final String subtitle;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: selected ? VaaniTheme.primaryContainer : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? VaaniTheme.primary : const Color(0xFFC7C4D7),
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: VaaniTheme.primary),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: VaaniTheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
