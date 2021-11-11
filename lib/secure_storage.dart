import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._internal();
  static final _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;

  static const _storage = FlutterSecureStorage();
  static late String idToken;

  static Future initSecureStorage() async {
    idToken = await _storage.read(key: 'idToken') ?? '';
  }

  static Future writeIdToken(String newToken) async {
    idToken = newToken;
    await _storage.write(key: 'idToken', value: newToken);
  }
}
