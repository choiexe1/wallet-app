import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talker/talker.dart';
import 'package:wallet_app/core/constants/app_color.dart';
import 'package:wallet_app/core/router/app_routes.dart';
import 'package:wallet_app/core/widgets/app_button.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/create_wallet_event.dart';
import 'package:wallet_app/injector.dart';

import '../bloc/create_wallet_bloc.dart';
import '../bloc/create_wallet_state.dart';

class CreateWalletPage extends StatelessWidget {
  const CreateWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<CreateWalletBloc, CreateWalletState>(
            listener: (context, state) {
              if (state is CreateWalletSuccess) {
                sl<Talker>().info(
                  'Wallet created: ${state.wallet.accounts.first.address}',
                );
                context.go(AppRoutes.home);
              }
            },
            builder: (context, state) {
              return switch (state) {
                CreateWalletInitial() || CreateWalletLoading() => Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      '지갑 생성',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const Text(
                      '지갑이 존재하지 않아요, 먼저 지갑을 생성해주세요.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      onPressed: () => context.read<CreateWalletBloc>().add(
                        CreateWalletSubmitted(),
                      ),
                      label: '새 지갑 만들기',
                      isLoading: state is CreateWalletLoading,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.importWallet),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColor.gray100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '기존 지갑 복구',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CreateWalletSuccess() => const SizedBox(),
                CreateWalletFailure() => Text(state.message),
              };
            },
          ),
        ),
      ),
    );
  }
}
