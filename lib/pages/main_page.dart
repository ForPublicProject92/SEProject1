import 'package:flutter/material.dart';
import 'calendar.dart';

// MainPage: 로그인/회원가입 이후 메인 페이지
// /calendar 버튼은 슬라이드 애니메이션으로 이동
// /configuration 버튼은 일반 push
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Slide 전환 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => CalendarPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽
                      const end = Offset.zero;
                      final tween = Tween(begin: begin, end: end);
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                  ),
                );
              },
              child: Text('Go to Calendar (Slide)'),
            ),
            // 일반 push
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/configuration'),
              child: Text('Go to Configuration'),
            ),
          ],
        ),
      ),
    );
  }
}
