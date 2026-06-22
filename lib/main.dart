import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/presentation/screens/home_screen.dart';
import 'package:focus_timer/presentation/providers/theme_provider.dart';
import 'package:focus_timer/shared/services/notification_service.dart';
import 'package:focus_timer/shared/theme/app_theme.dart';
import 'package:focus_timer/shared/widgets/permission_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    focusTimerSystemUiStyle(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    ),
  );
  await NotificationService.instance.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = ref.watch(themeColorProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Focus Timer',
      theme: buildFocusTimerTheme(
        seedColor: themeColor,
        brightness: Brightness.light,
      ),
      darkTheme: buildFocusTimerTheme(
        seedColor: themeColor,
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      home: const PermissionGate(child: HomeScreen()),
    );
  }
}
