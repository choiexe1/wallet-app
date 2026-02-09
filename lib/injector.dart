import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:wallet_app/core/address_generator.dart';
import 'package:wallet_app/core/crypto/entropy/entropy_generator.dart';
import 'package:wallet_app/core/crypto/entropy/entropy_generator_impl.dart';
import 'package:wallet_app/core/storage/secure_storage.dart';
import 'package:wallet_app/core/storage/storage.dart';
import 'package:wallet_app/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/create_wallet_bloc.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_bloc.dart';

final sl = GetIt.I;

void injection() {
  // Infra
  sl.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
  sl.registerSingleton<Storage>(SecureStorage(sl()));
  sl.registerSingleton<EntropyGenerator>(EntropyGeneratorImpl(Random.secure()));
  sl.registerSingleton<AddressGenerator>(EVMAddressGenerator());

  // Data
  sl.registerSingleton<WalletRepository>(WalletRepositoryImpl());

  // Presentation
  sl.registerFactory(() => WalletBloc(sl()));
  sl.registerFactory(() => CreateWalletBloc(sl()));
}
