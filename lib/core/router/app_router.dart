import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_app/core/storage/storage.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/create_wallet_bloc.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:wallet_app/features/wallet/presentation/pages/create_wallet_page.dart';
import 'package:wallet_app/features/wallet/presentation/pages/import_wallet_page.dart';
import 'package:wallet_app/features/wallet/presentation/pages/wallet_page.dart';
import 'package:wallet_app/injector.dart';

import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.createWallet,
  redirect: (context, state) async {
    final Storage storage = sl();
    final walletId = await storage.read('wallet_id');
    final location = state.matchedLocation;
    final isOnboarding =
        location == AppRoutes.createWallet ||
        location == AppRoutes.importWallet;

    if (walletId == null && !isOnboarding) return AppRoutes.createWallet;
    if (walletId != null && isOnboarding) return AppRoutes.home;

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return BlocProvider<WalletBloc>(
          create: (context) => sl()..add(const WalletLoaded()),
          child: const WalletPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.createWallet,
      builder: (context, state) {
        return BlocProvider<CreateWalletBloc>(
          create: (context) => sl(),
          child: const CreateWalletPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.importWallet,
      builder: (context, state) {
        return BlocProvider<CreateWalletBloc>(
          create: (context) => sl(),
          child: const ImportWalletPage(),
        );
      },
    ),
  ],
);
