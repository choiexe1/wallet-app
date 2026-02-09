import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/widgets/app_button.dart';

import '../bloc/create_wallet_bloc.dart';
import '../bloc/create_wallet_state.dart';

class CreateWalletPage extends StatelessWidget {
  const CreateWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<CreateWalletBloc, CreateWalletState>(
            builder: (context, state) {
              return switch (state) {
                CreateWalletInitial() || CreateWalletLoading() => Column(
                  spacing: 8,
                  crossAxisAlignment: .start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      '지갑 생성',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '지갑이 존재하지 않아요, 먼저 지갑을 생성해주세요.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      onPressed: () {},
                      label: '지갑 생성',
                      isLoading: state is CreateWalletLoading,
                    ),
                  ],
                ),
                CreateWalletSuccess() => Text('생성 완료: ${state.wallet.address}'),
                CreateWalletFailure() => Text(state.message),
              };
            },
          ),
        ),
      ),
    );
  }
}
