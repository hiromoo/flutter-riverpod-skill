import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/build_context_l10n.dart';
import '../application/settings_providers.dart';
import '../domain/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: settings.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(context.l.loadFailed),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(appSettingsControllerProvider),
                    child: Text(context.l.retry),
                  ),
                ]),
                data: (value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(context.l.settings, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(context.l.language, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<LocalePreference>(
                          initialValue: value.locale,
                          items: [
                            DropdownMenuItem(value: LocalePreference.system, child: Text(context.l.deviceLanguage)),
                            DropdownMenuItem(value: LocalePreference.japanese, child: Text(context.l.japanese)),
                            DropdownMenuItem(value: LocalePreference.english, child: Text(context.l.english)),
                          ],
                          onChanged: (locale) {
                            if (locale != null) _update(context, ref, value.copyWith(locale: locale));
                          },
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(context.l.appearance, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<ThemePreference>(
                          initialValue: value.theme,
                          items: [
                            DropdownMenuItem(value: ThemePreference.system, child: Text(context.l.deviceAppearance)),
                            DropdownMenuItem(value: ThemePreference.light, child: Text(context.l.lightTheme)),
                            DropdownMenuItem(value: ThemePreference.dark, child: Text(context.l.darkTheme)),
                          ],
                          onChanged: (theme) {
                            if (theme != null) _update(context, ref, value.copyWith(theme: theme));
                          },
                        ),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _update(BuildContext context, WidgetRef ref, AppSettings settings) async {
    try {
      await ref.read(appSettingsControllerProvider.notifier).saveSettings(settings);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l.saveFailed)));
      }
      return;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l.settingsSaved)));
    }
  }
}
