//configuration.dart
import 'package:flutter/material.dart';
import '../src/auth/local_storage.dart';

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: const Color(0xFFB695C0),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // --------------------------
          // 마이페이지
          // --------------------------
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("마이페이지"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, "/mypage");
            },
          ),

          const Divider(),

          // --------------------------
          // 가족 정보
          // --------------------------
          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text("가족 정보"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, "/family");
            },
          ),

          const Divider(),
          // --------------------------
          // 앱 정보
          // --------------------------
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("앱 정보"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, "/about");
            },
          ),

          const Divider(),
          const SizedBox(height: 20),

          // --------------------------
          // 로그아웃
          // --------------------------
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () async {
              await LocalAuthStorage.clear();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text("로그아웃"),
          ),
        ],
      ),
    );
  }
}
