import 'package:flutter/material.dart';
import 'pages/start.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/main_page.dart';
import 'pages/calendar.dart';
import 'pages/record.dart';
import 'pages/configuration.dart';
import 'pages/server_error.dart';
import 'pages/mypage.dart';
import 'pages/family.dart';
import 'pages/about.dart';
import 'pages/family_add.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null); // ★ 반드시 필요

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 첫 화면
      initialRoute: '/start',

      routes: {
        '/start': (_) => const StartPage(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/main': (_) => HomePage(),
        '/calendar': (_) => CalendarPage(),
        '/record': (_) => RecordPage(),
        '/configuration': (_) => ConfigurationPage(),
        '/serverError': (_) => const ServerErrorPage(),
        '/family': (_) => const FamilyPage(),
        '/family/add': (_) => const FamilyAddPage(),
        '/mypage': (_) => const MyPage(),
        '/about': (_) => const AboutPage(),
      },
    );
  }
}
