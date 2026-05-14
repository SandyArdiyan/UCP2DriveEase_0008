import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../services/token_service.dart';
import '../models/katalog_model.dart';
import '../models/kategori_model.dart';

class ApiRepository {
  final TokenService _tokenService = TokenService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _tokenService.getToken();
    if (token == null) {
      throw Exception('Sesi telah habis, silakan login kembali.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }


  // Ditambahkan fitur menerima parameter query untuk Search
  Future<List<KatalogModel>> getKatalog({String query = ''}) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/katalog?search=$query'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data']; 
      return data.map((json) => KatalogModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data katalog: Code ${response.statusCode}');
    }
  }

  Future<void> createKatalog(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/katalog'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal menambah armada: Code ${response.statusCode}');
    }
  }

  Future<void> updateKatalog(int id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}/katalog/$id'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah data armada');
    }
  }

  Future<void> deleteKatalog(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/katalog/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus armada');
    }
  }

  // --- CRUDS KATEGORI ---

  Future<List<KategoriModel>> getKategori() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/kategori'), 
      headers: headers
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => KategoriModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data kategori');
    }
  }

  Future<void> createKategori(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/kategori'), 
      headers: headers, 
      body: jsonEncode(data)
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal menambah kategori');
    }
  }

  Future<void> updateKategori(int id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}/kategori/$id'), 
      headers: headers, 
      body: jsonEncode(data)
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah kategori');
    }
  }

  Future<void> deleteKategori(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/kategori/$id'), 
      headers: headers
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus kategori');
    }
  }
}