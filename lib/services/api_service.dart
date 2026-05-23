import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // PENTING: Ganti IP ini dengan IP komputer kamu jika testing di HP fisik
  // Untuk emulator Android: 10.0.2.2
  // Untuk HP fisik: IP WiFi komputer (cek dengan ipconfig)
  static const String baseUrl = 'http://localhost/New%20folder/api';

  // ==================== AUTH ====================
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(String nama, String email, String telepon, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama': nama, 'email': email, 'telepon': telepon, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // ==================== DATA ====================
  static Future<List<dynamic>> getJadwal() async {
    final response = await http.get(Uri.parse('$baseUrl/jadwal.php'));
    final data = jsonDecode(response.body);
    return data['success'] ? data['data'] : [];
  }

  static Future<List<dynamic>> getTarif() async {
    final response = await http.get(Uri.parse('$baseUrl/tarif.php'));
    final data = jsonDecode(response.body);
    return data['success'] ? data['data'] : [];
  }

  static Future<List<dynamic>> getRute() async {
    final response = await http.get(Uri.parse('$baseUrl/rute.php'));
    final data = jsonDecode(response.body);
    return data['success'] ? data['data'] : [];
  }

  static Future<List<dynamic>> getTips() async {
    final response = await http.get(Uri.parse('$baseUrl/tips.php'));
    final data = jsonDecode(response.body);
    return data['success'] ? data['data'] : [];
  }

  static Future<Map<String, dynamic>> getPengaturan() async {
    final response = await http.get(Uri.parse('$baseUrl/pengaturan.php'));
    final data = jsonDecode(response.body);
    return data['success'] ? Map<String, dynamic>.from(data['data']) : {};
  }

  // ==================== BOOKING ====================
  static Future<Map<String, dynamic>> pesanTiket(Map<String, dynamic> bookingData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pesan_tiket.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bookingData),
    );
    return jsonDecode(response.body);
  }

  // ==================== SESSION ====================
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', int.parse(user['id'].toString()));
    await prefs.setString('user_nama', user['nama']);
    await prefs.setString('user_email', user['email']);
    await prefs.setString('user_telepon', user['telepon'] ?? '');
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    if (id == null) return null;
    return {
      'id': id,
      'nama': prefs.getString('user_nama') ?? '',
      'email': prefs.getString('user_email') ?? '',
      'telepon': prefs.getString('user_telepon') ?? '',
    };
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') != null;
  }
}
