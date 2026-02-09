import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc(this._walletRepository) : super(const WalletInitial()) {
    on<WalletLoaded>(_onLoaded);
  }

  final WalletRepository _walletRepository;

  Future<void> _onLoaded(WalletLoaded event, Emitter<WalletState> emit) async {
    emit(const WalletLoading());
    try {
      final wallet = await _walletRepository.loadWallet();
      if (wallet != null) {
        emit(WalletLoadSuccess(wallet));
      } else {
        emit(const WalletInitial());
      }
    } catch (e) {
      emit(WalletFailure(e.toString()));
    }
  }
}
