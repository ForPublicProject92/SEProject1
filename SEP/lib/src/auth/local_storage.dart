import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalAuthStorage {
  static final storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  static Future<void> saveUserId(String id) async {
    await storage.write(key: "userId", value: id);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  static Future<String?> getUserId() async {
    return await storage.read(key: "userId");
  }

  static Future<void> clear() async {
    await storage.delete(key: "token");
    await storage.delete(key: "userId");
  }
}
