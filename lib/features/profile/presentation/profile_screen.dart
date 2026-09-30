import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescuelink/features/auth/presentation/providers/auth_provider.dart';
import 'package:rescuelink/features/profile/presentation/providers/locale_provider.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final highContrast = ref.watch(highContrastProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.email ?? 'Utilisateur',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          user != null ? 'Connecté' : 'Mode Invité',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l10n.authLogout),
                          content: Text(l10n.authLogoutConfirm),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(l10n.actionCancel),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(l10n.authLogout),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await ref.read(authRepositoryProvider).signOut();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Internationalization (Language)
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.profileLanguage),
            trailing: DropdownButton<Locale>(
              value: currentLocale,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(
                  value: Locale('fr'),
                  child: Text('Français'),
                ),
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
              ],
              onChanged: (newLocale) {
                if (newLocale != null) {
                  ref.read(localeProvider.notifier).state = newLocale;
                }
              },
            ),
          ),
          const Divider(),

          // Theme Selector
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(l10n.profileTheme),
            trailing: DropdownButton<ThemeMode>(
              value: currentThemeMode,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.profileThemeSystem),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.profileThemeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(l10n.profileThemeDark),
                ),
              ],
              onChanged: (newMode) {
                if (newMode != null) {
                  ref.read(themeModeProvider.notifier).state = newMode;
                }
              },
            ),
          ),
          const Divider(),

          // Accessibility Options
          SwitchListTile(
            secondary: const Icon(Icons.accessibility_new),
            title: Text(l10n.profileHighContrast),
            value: highContrast,
            onChanged: (val) {
              ref.read(highContrastProvider.notifier).state = val;
            },
          ),
          const Divider(),

          // Version info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'RescueLink v1.0.0+1',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
