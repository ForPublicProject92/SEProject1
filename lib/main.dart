import 'package:flutter/material.dart';

// 각 페이지 import
import 'pages/start.dart';
import 'pages/select.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/main_page.dart';
import 'pages/configuration.dart';
import 'pages/calendar.dart';
import 'pages/record.dart';

void main() => runApp(MyApp());

// MyApp: 전체 앱 루트
// MaterialApp을 사용하여 route와 기본 테마 지정
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniPro Example',

      // 앱 실행 시 시작 페이지
      initialRoute: '/start',

      // 페이지 경로(route) 정의
      routes: {
        '/start': (context) => StartPage(),
        '/select': (context) => SelectPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/main': (context) => MainPage(),
        '/configuration': (context) => ConfigurationPage(),
        '/calendar': (context) => CalendarPage(),
        '/record': (context) => RecordPage(),
      },
    );
  }
}
