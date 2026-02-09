import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_state.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Page')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              return switch (state) {
                WalletInitial() => const Text('지갑이 없습니다'),
                WalletLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                WalletLoadSuccess() => Text(state.wallet.address),
                WalletFailure() => Text(state.message),
              };
            },
          ),
        ),
      ),
    );
  }
}
