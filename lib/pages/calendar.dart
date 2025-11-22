import 'package:flutter/material.dart';
import 'main_page.dart';
import 'record.dart';

// calendarPage: 일정 페이지
// mainPage ↔ CalendarPage 슬라이드 전환
class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Slide 전환 버튼 (Calendar → Main)
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0); // 왼쪽에서 오른쪽
                    const end = Offset.zero;
                    final tween = Tween(begin: begin, end: end);
                    return SlideTransition(position: animation.drive(tween), child: child);
                  },
                ),
              );
            },
            child: Text('Back to Main (Slide)'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/record'),
            child: Text('Go to Record'),
          ),
        ],
      ),
    );
  }
}
