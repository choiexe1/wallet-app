import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_theme.dart';
import 'package:wallet_app/injector.dart';

import 'core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  injection();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Wallet App',
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
