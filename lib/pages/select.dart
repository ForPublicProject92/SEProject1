import 'package:flutter/material.dart';

// SelectPage: 로그인/회원가입 선택 페이지
// 두 개 버튼으로 /login 또는 /signup으로 이동
class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: Text('Login'), // 로그인 버튼
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            child: Text('Sign Up'), // 회원가입 버튼
          ),
        ],
      ),
    );
  }
}
