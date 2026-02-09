import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/entities/token.dart';
import 'package:wallet_app/core/network/eth_rpc_client.dart';

import '../../domain/repositories/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc(this._walletRepository, this._rpcClient)
    : super(const WalletInitial()) {
    on<WalletLoaded>(_onLoaded);
    on<WalletDeleted>(_onDeleted);
    on<AccountAdded>(_onAccountAdded);
    on<TokenSelected>(_onTokenSelected);
  }

  final WalletRepository _walletRepository;
  final EthRpcClient _rpcClient;

  Future<Map<String, Map<String, String>>> _fetchAllBalances(
    List<String> addresses,
  ) async {
    final result = <String, Map<String, String>>{};
    for (final address in addresses) {
      final tokenBalances = <String, String>{};
      for (final token in SupportedTokens.all) {
        try {
          final BigInt raw;
          if (token.isNative) {
            raw = await _rpcClient.getBalance(address);
          } else {
            raw = await _rpcClient.getTokenBalance(
              token.contractAddress!,
              address,
            );
          }
          tokenBalances[token.symbol] = EthRpcClient.formatUnits(
            raw,
            token.decimals,
          );
        } catch (_) {
          tokenBalances[token.symbol] = '0';
        }
      }
      result[address] = tokenBalances;
    }
    return result;
  }

  Future<void> _onLoaded(WalletLoaded event, Emitter<WalletState> emit) async {
    emit(const WalletLoading());
    try {
      final wallet = await _walletRepository.loadWallet();
      if (wallet != null) {
        final balances = await _fetchAllBalances(
          wallet.accounts.map((a) => a.address).toList(),
        );
        emit(WalletLoadSuccess(wallet, balances: balances));
      } else {
        emit(const WalletInitial());
      }
    } catch (e) {
      emit(WalletFailure(e.toString()));
    }
  }

  Future<void> _onDeleted(
    WalletDeleted event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());
    try {
      await _walletRepository.deleteWallet();
      emit(const WalletInitial());
    } catch (e) {
      emit(WalletFailure(e.toString()));
    }
  }

  Future<void> _onAccountAdded(
    AccountAdded event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final wallet = await _walletRepository.loadWallet();
      if (wallet == null) {
        emit(const WalletInitial());
        return;
      }
      await _walletRepository.addAccount(wallet.id);
      final updated = await _walletRepository.loadWallet();
      if (updated != null) {
        final balances = await _fetchAllBalances(
          updated.accounts.map((a) => a.address).toList(),
        );
        emit(WalletLoadSuccess(updated, balances: balances));
      } else {
        emit(const WalletInitial());
      }
    } catch (e) {
      emit(WalletFailure(e.toString()));
    }
  }

  void _onTokenSelected(TokenSelected event, Emitter<WalletState> emit) {
    final current = state;
    if (current is WalletLoadSuccess) {
      emit(current.copyWith(selectedToken: event.token));
    }
  }
}
