import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("시작하기"),
          onPressed: () => Navigator.pushNamed(context, '/login'),
        ),
      ),
    );
  }
}
