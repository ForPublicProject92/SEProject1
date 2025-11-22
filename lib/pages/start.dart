import 'package:flutter/material.dart';

// StartPage: 앱 시작 페이지
// 버튼 클릭 시 /select 페이지로 이동
class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/select'),
          child: Text('Go to Select'), // 버튼 라벨
        ),
      ),
    );
  }
}
