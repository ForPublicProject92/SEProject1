import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("앱 정보"),
        backgroundColor: const Color(0xFFB695C0),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------
            // 로고 또는 앱 이름
            // -----------------------
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.local_florist,
                    size: 80,
                    color: Colors.purple[300],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "라일락 (Lilac)",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "버전 1.0.0",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // -----------------------
            // 앱 설명
            // -----------------------
            const Text(
              "앱 소개",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "설명문.\n",
              style: TextStyle(fontSize: 15, height: 1.4),
            ),

            const SizedBox(height: 30),

            // -----------------------
            // 개발자 정보
            // -----------------------
            const Text(
              "개발 정보",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "개발팀: \n"
              "사용 기술: Flutter, Node.js, MongoDB, Docker\n"
              "문의: support@lilac-app.com",
              style: TextStyle(fontSize: 15, height: 1.4),
            ),

            const Spacer(),

            // -----------------------
            // 하단 카피라이트
            // -----------------------
            Center(
              child: Text(
                "© 2025 Lilac. All rights reserved.",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
