// api_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:async'; 

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/global_error.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:2803";
  static const storage = FlutterSecureStorage();

  // 토큰 가져오기
  static Future<String?> getToken() async => await storage.read(key: "token");

  // =============================
  // 서버 상태 체크
  // =============================
  static Future<bool> checkServer() async {
    try {
      final res = await http
          .get(Uri.parse("$baseUrl/api/health"))
          .timeout(const Duration(seconds: 3));

      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // =============================
  // 로컬 저장된 토큰 서버 검증
  // =============================
  static Future<bool> verifyStoredToken() async {
    final token = await getToken();
    print("[verifyStoredToken] raw token = [$token]");

    if (token == null || token.isEmpty) return false;

    try {
      final res = await http.get(
        Uri.parse("$baseUrl/api/auth/verify"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("🔎 [verifyStoredToken] header sent = Bearer $token");
      print("🔎 [verifyStoredToken] status = ${res.statusCode}");
      print("🔎 [verifyStoredToken] body = ${res.body}");

      return res.statusCode == 200;
    } catch (e) {
      print("verifyStoredToken error: $e");
      return false;
    }
  }


  // =============================
  // 공통 GET
  // =============================
  static Future<dynamic> get(BuildContext context, String endpoint) async {
    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse("$baseUrl$endpoint"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }

      if (res.statusCode >= 500) {
        GlobalError.showServerError(context);
      }

      throw Exception("GET 실패: $endpoint, 상태: ${res.statusCode}");

    } on SocketException catch (_) {
      GlobalError.showServerError(context);
      rethrow;
    } on TimeoutException catch (_) {
      GlobalError.showServerError(context);
      rethrow;
    }
  }

  // =============================
  // 공통 POST
  // =============================
  static Future<Map<String, dynamic>> post(
    BuildContext context,
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await getToken();

      final res = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token"
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }

      if (res.statusCode >= 500) {
        GlobalError.showServerError(context);
      }

      throw Exception("POST 실패: $endpoint, 상태: ${res.statusCode}");

    } on SocketException catch (_) {
      GlobalError.showServerError(context);
      rethrow;
    } on TimeoutException catch (_) {
      GlobalError.showServerError(context);
      rethrow;
    }
  }
}
