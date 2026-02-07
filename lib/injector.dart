import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:wallet_app/core/address_generator.dart';
import 'package:wallet_app/core/entropy_generator.dart';
import 'package:wallet_app/core/hasher.dart';
import 'package:wallet_app/core/hd_key_derivator.dart';
import 'package:wallet_app/core/storage.dart';
import 'package:wallet_app/pages/wallet_view_model.dart';

final sl = GetIt.I;

Future<void> injection() async {
  sl.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());

  sl.registerSingleton<Storage>(SecureStorage(sl()));
  sl.registerSingleton(EntropyGenerator(Random.secure()));
  sl.registerSingleton<Hasher>(SHA256Hasher());
  sl.registerSingleton<HdKeyDerivator>(HdKeyDerivatorImpl());
  sl.registerSingleton<AddressGenerator>(EVMAddressGenerator());

  sl.registerFactory(() => WalletViewModel(sl(), sl(), sl(), sl(), sl()));
}
