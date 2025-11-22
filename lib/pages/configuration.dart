import 'package:flutter/material.dart';

// ConfigurationPage: 설정 페이지
// /main으로 이동
class ConfigurationPage extends StatelessWidget {
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
        ],
      ),
    );
  }
}
