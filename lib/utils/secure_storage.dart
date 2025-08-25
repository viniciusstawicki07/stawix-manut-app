import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Uma classe wrapper para o FlutterSecureStorage para gerenciar
/// o armazenamento de tokens de autenticação.
class SecureStorage {
  final _storage = const FlutterSecureStorage();

  /// Escreve um token no armazenamento seguro.
  Future<void> writeToken(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Lê um token do armazenamento seguro.
  Future<String?> readToken(String key) async {
    return await _storage.read(key: key);
  }

  /// Apaga todos os tokens do armazenamento seguro (usado para logout).
  Future<void> deleteAllTokens() async {
    await _storage.deleteAll();
  }
}
