import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:wallet_app/core/theme/app_theme.dart';
import 'package:wallet_app/injector.dart';

import 'core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  injection();

  final talker = sl<Talker>();
  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: TalkerBlocLoggerSettings(
      printEvents: true,
      printTransitions: true,
      printChanges: true,
      printCreations: true,
      printClosings: true,
    ),
  );
  talker.info('App started');

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
