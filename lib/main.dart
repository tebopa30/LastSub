import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/breast_notification_service.dart';
import 'core/providers/notification_service.dart';
import 'core/providers/navigator_key_provider.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/task/presentation/task_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('[FlutterError] ${details.exceptionAsString()}');
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('[PlatformError] $error');
    return true;
  };

  await BreastNotificationService.instance.initialize();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const LastSubApp(),
    ),
  );
}

class LastSubApp extends ConsumerWidget {
  const LastSubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationServiceProvider);

    final navigatorKey = ref.watch(navigatorKeyProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'LastSub',
      theme: AppTheme.softLightTheme,
      darkTheme: AppTheme.deepDarkTheme,
      themeMode: themeMode,
      navigatorKey: navigatorKey,
      home: const TaskListPage(),
    );
  }
}
