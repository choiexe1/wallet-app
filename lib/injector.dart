import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:wallet_app/core/entropy_generator.dart';
import 'package:wallet_app/core/hasher.dart';
import 'package:wallet_app/core/storage.dart';
import 'package:wallet_app/pages/view_model.dart';

final sl = GetIt.I;

Future<void> injection() async {
  sl.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());

  sl.registerSingleton<Storage>(SecureStorage(sl()));
  sl.registerSingleton(EntropyGenerator());
  sl.registerSingleton<Hasher>(SHA256Hasher());

  sl.registerFactory(() => ViewModel(sl(), sl(), sl()));
}
