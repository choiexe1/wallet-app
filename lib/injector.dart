import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';
import 'package:wallet_app/core/crypto/entropy/entropy_generator.dart';
import 'package:wallet_app/core/crypto/entropy/entropy_generator_impl.dart';
import 'package:wallet_app/core/crypto/wallet/wallet_generator.dart';
import 'package:wallet_app/core/crypto/wallet/wallet_generator_impl.dart';
import 'package:wallet_app/core/http/dio_client.dart';
import 'package:wallet_app/core/network/eth_rpc_client.dart';
import 'package:wallet_app/core/storage/secure_storage.dart';
import 'package:wallet_app/core/storage/storage.dart';
import 'package:wallet_app/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/create_wallet_bloc.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_bloc.dart';

final sl = GetIt.I;

void injection() {
  // Logging
  sl.registerSingleton<Talker>(
    Talker(
      logger: TalkerLogger(settings: TalkerLoggerSettings(enableColors: false)),
    ),
  );

  // Infra
  sl.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
  sl.registerSingleton<Storage>(SecureStorage(sl()));
  sl.registerSingleton<EntropyGenerator>(EntropyGeneratorImpl(Random.secure()));
  sl.registerSingleton<WalletGenerator>(WalletGeneratorImpl(sl()));

  // Network
  sl.registerSingleton<Dio>(
    DioClient(
      baseUrl: 'https://polygon-amoy.g.alchemy.com/v2/CyAz2kCbSWbtbWiOcOPTH',
    ),
  );
  sl.registerSingleton<EthRpcClient>(EthRpcClient(sl()));

  // Data
  sl.registerSingleton<WalletRepository>(WalletRepositoryImpl(sl(), sl()));

  // Presentation
  sl.registerFactory(() => WalletBloc(sl(), sl()));
  sl.registerFactory(() => CreateWalletBloc(sl()));
}
