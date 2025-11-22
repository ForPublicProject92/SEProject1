import 'package:flutter/material.dart';

// SignupPage: 회원가입 페이지
// 회원가입 후 /login으로 이동
class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: Text('Go to Login'), // 회원가입 완료 시
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
