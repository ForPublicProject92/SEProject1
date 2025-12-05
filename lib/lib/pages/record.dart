import 'package:flutter/material.dart';

// record: 기록 페이지
// /calendar로 돌아가기
class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/calendar'),
          child: Text('Back to Calendar'),
        ),
      ),
    );
  }
}
