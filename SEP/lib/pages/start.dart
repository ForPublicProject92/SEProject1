import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    initProcess();
  }

Future<void> initProcess() async {
  final serverOK = await ApiService.checkServer();
  print("serverOK = $serverOK");

  // 저장된 토큰 확인
  final savedToken = await ApiService.getToken();

  if (!serverOK) {
    if (!mounted) return;
    print("서버 연결 실패 → /serverError 이동");
    Navigator.pushReplacementNamed(context, '/serverError');
    return;
  }
  final validToken = await ApiService.verifyStoredToken();
  print("validToken = $validToken");

  if (!mounted) return;

  if (validToken) {
    print("유효한 토큰 → /main");
    Navigator.pushReplacementNamed(context, '/main');
  } else {
    print("토큰 없음/유효하지 않음 → /login");
    Navigator.pushReplacementNamed(context, '/login');
  }
}


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

