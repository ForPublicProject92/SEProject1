import 'package:flutter/material.dart';

class ServerErrorPage extends StatelessWidget {
  const ServerErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("서버 오류")),
      body: const Center(
        child: Text(
          "서버와 통신할 수 없습니다.\n잠시 후 다시 시도해주세요.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
