import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../src/auth/local_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idCtrl = TextEditingController();
  final pwCtrl = TextEditingController();

  Future<void> login() async {
    try {
      // 로그인 요청
      final res = await ApiService.post("/auth/login", {
        "id": idCtrl.text.trim(),
        "password": pwCtrl.text.trim(),
      });

      // 토큰 저장 (자동로그인용)
      await LocalAuthStorage.saveToken(res["token"]);
      await LocalAuthStorage.saveUserId(res["id"]);

      // 메인 페이지 이동
      Navigator.pushReplacementNamed(
        context,
        '/main',
        arguments: res["id"],
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("로그인 실패")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로그인")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: "ID"),
            ),
            TextField(
              controller: pwCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "PW"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text("로그인"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/signup"),
              child: const Text("회원가입"),
            )
          ],
        ),
      ),
    );
  }
}
