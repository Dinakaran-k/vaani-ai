import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secretStoreProvider = Provider<SecretStore>(
  (_) => SecretStore(const FlutterSecureStorage()),
);

class SecretStore {
  const SecretStore(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }
}
