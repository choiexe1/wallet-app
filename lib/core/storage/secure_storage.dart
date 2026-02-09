import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_app/core/storage/storage.dart';

class SecureStorage implements Storage {
  const SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
