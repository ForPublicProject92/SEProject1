import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/lilac_character.dart';
import '../src/today_question_dialog.dart';
import '../src/weather/weather_api.dart';
import '../src/weather/weather_function.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    super.initState();
    _checkFamilyInvites();   // ← 가족 초대 자동 체크
  }

  // ------------------------------------------
  //   가족 초대 확인 → 팝업 자동 표시
  // ------------------------------------------
  Future<void> _checkFamilyInvites() async {
    try {
      final invites = await ApiService.get(context, "/api/family/invites");

      if (invites is List && invites.isNotEmpty) {
        final invite = invites.first;

        // 팝업 자동 출력
        if (mounted) {
          _showInvitePopup(invite);
        }
      }
    } catch (e) {
      print("가족 초대 조회 실패: $e");
    }
  }

  // ------------------------------------------
  //   초대 팝업 UI
  // ------------------------------------------
  Future<void> _showInvitePopup(dynamic invite) async {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 터치로 닫히지 않음
      builder: (_) {
        return AlertDialog(
          title: const Text("가족 초대가 도착했습니다!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("초대한 사람 ID: ${invite["from"]}"),
              const SizedBox(height: 12),
              const Text("가족으로 등록하시겠습니까?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _denyInvite(invite);
              },
              child: const Text("누구세요?"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _acceptInvite(invite);
              },
              child: const Text("가족 맞아요"),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------
  //   초대 수락 / 거절 기능
  // ------------------------------------------

  Future<void> _acceptInvite(dynamic invite) async {
    try {
      await ApiService.post(
        context,
        "/api/family/accept",
        {"family_code": invite["family_code"]},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("가족으로 등록되었습니다.")),
      );
    } catch (e) {
      print("초대 수락 실패: $e");
    }
  }

  Future<void> _denyInvite(dynamic invite) async {
    try {
      await ApiService.post(
        context,
        "/api/family/deny",
        {"family_code": invite["family_code"]},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("초대를 거절했습니다.")),
      );
    } catch (e) {
      print("초대 거절 실패: $e");
    }
  }


  // ------------------------------------------
  //   기존의 HomePage UI 그대로 유지
  // ------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("라일락"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/configuration').then((refresh) {
                if (refresh == true) setState(() {});
                });
            },
          )
        ],
        backgroundColor: const Color(0xFFB695C0),
      ),

      body: Stack(
        children: [
          // -----------------------------
          // 날씨 표시
          // -----------------------------
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              width: 200,
              height: 150,
              child: Center(
                child: FutureBuilder<String>(
                  future: fetchWeather(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(strokeWidth: 2);
                    }
                    if (snap.hasError) {
                      return const Text("날씨 로드 실패");
                    }

                    final data = snap.data ?? '';
                    final parts = data.split('-');
                    final sky = parts.isNotEmpty ? parts[0] : '';
                    final pty = parts.length > 1 ? parts[1] : '0';

                    final mapped = WeatherFunction.funcWeather(sky, pty);

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        mapped['icon'] as Widget,
                        const SizedBox(height: 6),
                        Text(
                          "현재 날씨 - ${mapped['description']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // -----------------------------
          // 캐릭터
          // -----------------------------
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LilacCharacter(answeredDaysCount: 7),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // -----------------------------
          // 달력 버튼
          // -----------------------------
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, "/calendar"),
              icon: const Icon(Icons.calendar_month),
              label: const Text("달력"),
            ),
          ),

          // -----------------------------
          // 오늘의 질문 버튼
          // -----------------------------
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => TodayQuestionDialog.show(context),
              child: const Icon(Icons.chat_bubble),
            ),
          ),
        ],
      ),
    );
  }
}
