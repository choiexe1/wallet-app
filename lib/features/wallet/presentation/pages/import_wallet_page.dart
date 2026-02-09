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

class ImportWalletPage extends StatefulWidget {
  const ImportWalletPage({super.key});

  @override
  State<ImportWalletPage> createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage> {
  final _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _validate() {
    final words = _controller.text.trim().split(RegExp(r'\s+'));
    if (words.length != 12 || _controller.text.trim().isEmpty) {
      setState(() => _errorText = '12개의 단어를 입력해주세요');
      return false;
    }
    setState(() => _errorText = null);
    return true;
  }

  void _onSubmit() {
    if (!_validate()) return;
    context.read<CreateWalletBloc>().add(
      ImportWalletSubmitted(_controller.text.trim()),
    );
  }

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
                  'Wallet imported: ${state.wallet.accounts.first.address}',
                );
                context.go(AppRoutes.home);
              }
              if (state is CreateWalletFailure) {
                setState(() => _errorText = state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is CreateWalletLoading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 22,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '지갑 복구',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '기존 지갑의 복구 문구 12단어를 입력해주세요.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _errorText != null
                            ? AppColor.error
                            : AppColor.gray300,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColor.textPrimary,
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: '단어 사이에 공백을 넣어 입력해주세요',
                        hintStyle: TextStyle(
                          color: AppColor.textDisabled,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorText!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColor.error,
                      ),
                    ),
                  ],
                  const Spacer(),
                  AppButton(
                    onPressed: _onSubmit,
                    label: '복구하기',
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
