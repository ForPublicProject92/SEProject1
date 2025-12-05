// lib/src/setting_menu.dart/setting_function.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _controller = TextEditingController();
  String? _savedKey;

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  Future<void> _loadKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedKey = prefs.getString('weather_api_key');
      _controller.text = _savedKey ?? '';
    });
  }

  Future<void> _saveKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weather_api_key', _controller.text.trim());
    setState(() {
      _savedKey = _controller.text.trim();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("API 키가 저장되었습니다.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("설정")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "날씨 API 키",
                hintText: "발급받은 API 키를 입력하세요",
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveKey,
              child: Text("저장"),
            ),
          ],
        ),
      ),
    );
  }
}