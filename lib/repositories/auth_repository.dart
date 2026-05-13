import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../services/token_service.dart'; // Wajib import ini

class AuthRepository {
  final TokenService _tokenService = TokenService(); // Panggil alat penyimpannya

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // INI YANG PALING PENTING: Simpan tokennya ke HP!
      await _tokenService.saveToken(data['token']); 
      
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Login Gagal');
    }
  }
}