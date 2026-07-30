import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/base/app_activity_notifier.dart';
import '../core/constants/app_strings.dart';
import '../core/di/service_locator.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

/// App acts as the roots of our Flutter Application, wiring routers, themes, and global providers.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Register the global event bus activity notifier in the provider tree
        ChangeNotifierProvider<AppActivityNotifier>.value(
          value: locator<AppActivityNotifier>(),
        ),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            ThemeMode.system, // Dynamically matches user system preferences
        routerConfig: AppRouter.router,
      ),
    );
  }
}
