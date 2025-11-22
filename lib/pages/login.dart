import 'package:flutter/material.dart';

// LoginPage: 로그인 페이지
// 로그인 후 메인 페이지로 이동 가능
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/main'),
            child: Text('Go to Main'), // 로그인 완료 시 이동
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/select'),
            child: Text('Back to Select'), // 뒤로가기
          ),
        ],
      ),
    );
  }
}
