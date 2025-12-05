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
    // 1) 서버 상태 체크
    final serverOK = await ApiService.checkServer();
    if (!serverOK) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/serverError');
      return;
    }

    // 2) 토큰 검증
    final validToken = await ApiService.verifyStoredToken();
    if (!mounted) return;

    if (validToken) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
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
