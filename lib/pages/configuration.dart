import 'package:flutter/material.dart';
import '../src/auth/local_storage.dart';

// ConfigurationPage: 설정 페이지
// /main으로 이동
class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuration')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/main'),
            child: Text('Back to Main'),
          ),
          ElevatedButton(
            onPressed: () async {
              // 저장된 토큰 & 사용자 정보 삭제
              await LocalAuthStorage.clear();

              // 로그인 화면으로 이동 + 모든 페이지 스택 삭제
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text("로그아웃"),
          )
        ],
      ),
    );
  }
}
