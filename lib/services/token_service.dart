import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final _storage = const FlutterSecureStorage();
  final String _tokenKey = 'jwt_token';
  final String _nameKey = 'user_name'; // Tambahan kunci untuk nama

  // Simpan Token saja (untuk kompatibilitas kode lama)
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Simpan Token sekaligus Nama (Ini yang baru)
  Future<void> saveTokenAndName(String token, String name) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _nameKey, value: name);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getName() async {
    return await _storage.read(key: _nameKey);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _nameKey); // Hapus nama saat logout
  }
}