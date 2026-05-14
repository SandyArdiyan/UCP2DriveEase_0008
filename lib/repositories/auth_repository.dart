import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  // Pastikan URL-nya sudah benar sesuai jaringanmu
  final String baseUrl = 'http://10.0.2.2:3000/api/auth'; 

  // Fungsi Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Gagal menyambung ke jaringan: $e');
    }
  }

  // Fungsi Register 
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': name,
          'email': email,
          'password': password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Gagal menyambung ke jaringan: $e');
    }
  }
}