import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";
  static const storage = FlutterSecureStorage();

  // 토큰 가져오기
  static Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  // 공통 GET
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await getToken();
    final res = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("GET 실패 $endpoint");
  }

  // 공통 POST
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final token = await getToken();
    final res = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("POST 실패 $endpoint");
  }
}
