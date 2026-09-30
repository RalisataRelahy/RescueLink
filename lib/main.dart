import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rescuelink/core/constants/app_constants.dart';
import 'package:rescuelink/core/router/app_router.dart';
import 'package:rescuelink/core/theme/app_theme.dart';
import 'package:rescuelink/core/utils/notification_service.dart';
import 'package:rescuelink/core/utils/sync_service.dart';
import 'package:rescuelink/features/profile/presentation/providers/locale_provider.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    publishableKey: AppConstants.supabaseAnonKey,
  );

  await NotificationService.initialize();

  runApp(const ProviderScope(child: RescueLinkApp()));
}

class RescueLinkApp extends ConsumerWidget {
  const RescueLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncServiceProvider);
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'RescueLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
