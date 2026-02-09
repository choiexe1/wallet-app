import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/wallet_repository.dart';
import 'create_wallet_event.dart';
import 'create_wallet_state.dart';

class CreateWalletBloc extends Bloc<CreateWalletEvent, CreateWalletState> {
  CreateWalletBloc(this._repository) : super(const CreateWalletInitial()) {
    on<CreateWalletSubmitted>(_onSubmitted);
    on<ImportWalletSubmitted>(_onImported);
  }

  final WalletRepository _repository;

  Future<void> _onSubmitted(
    CreateWalletSubmitted event,
    Emitter<CreateWalletState> emit,
  ) async {
    emit(const CreateWalletLoading());
    try {
      final wallet = await _repository.createWallet();
      emit(CreateWalletSuccess(wallet));
    } catch (e) {
      emit(CreateWalletFailure(e.toString()));
    }
  }

  Future<void> _onImported(
    ImportWalletSubmitted event,
    Emitter<CreateWalletState> emit,
  ) async {
    emit(const CreateWalletLoading());
    try {
      final wallet = await _repository.importWallet(event.mnemonic);
      emit(CreateWalletSuccess(wallet));
    } catch (e) {
      emit(CreateWalletFailure(e.toString()));
    }
  }
}
