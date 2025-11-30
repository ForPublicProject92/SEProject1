import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final idCtrl = TextEditingController();
  final pwCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  Future<void> signup() async {
    try {
      await ApiService.post("/auth/signup", {
        "id": idCtrl.text,
        "password": pwCtrl.text,
        "name": nameCtrl.text,
        "phone": phoneCtrl.text,
      });
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("회원가입 실패")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(controller: idCtrl, decoration: const InputDecoration(labelText: "ID")),
            TextField(controller: pwCtrl, obscureText: true, decoration: const InputDecoration(labelText: "PW")),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "이름")),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "전화번호")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: signup, child: const Text("등록")),
          ],
        ),
      ),
    );
  }
}
