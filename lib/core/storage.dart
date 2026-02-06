import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class Storage {
  Future<void> saveString(String key, String value);
  Future<String?> readString(String key);
  Future<void> delete(String key);
}

class SecureStorage implements Storage {
  const SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> readString(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
