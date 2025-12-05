import '../src/today_question_dialog.dart';
import '../src/weather/weather_api.dart';
import '../src/weather/weather_function.dart';
import 'package:flutter/material.dart';
import '../widgets/lilac_character.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showQuestionBubble = false;
  String todayQuestion = "";

  @override
  void initState() {
    super.initState();
    checkTodayQuestion();
  }

  Future<void> checkTodayQuestion() async {
    try {
      final data = await ApiService.get(context, "/api/question/today");

      setState(() {
        todayQuestion = data["question"] ?? "";
        showQuestionBubble = (data["answer"] == null || data["answer"].isEmpty);
      });
    } catch (e) {
      // 서버 불안정 시 무시하고 UI만 표시
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("라일락"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/configuration');
            },
          )
        ],
      ),

      body: Stack(
        children: [
          // ----------------------------------------
          // 1) 날씨
          // ----------------------------------------
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              width: 200,
              height: 150,
              child: Center(
                child: FutureBuilder<String>(
                  future: fetchWeather(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(strokeWidth: 2);
                    }
                    if (snap.hasError) {
                      return Text("날씨 로드 실패");
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
                        SizedBox(height: 6),
                        Text("현재 날씨 - ${mapped['description']}"),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // ----------------------------------------
          // 2) 캐릭터 (중앙)
          // ----------------------------------------
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    LilacCharacter(answeredDaysCount: 7),

                    // ----------------------------------------
                    // 오늘의 질문 알림 말풍선
                    // ----------------------------------------
                    if (showQuestionBubble)
                      GestureDetector(
                        onTap: () {
                          TodayQuestionDialog.show(context);
                          setState(() => showQuestionBubble = false);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          margin: EdgeInsets.only(bottom: 130),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 6,
                                  color: Colors.black26,
                                  offset: Offset(0, 3))
                            ],
                          ),
                          child: Text(
                            "오늘 질문이 있어요!\n확인해볼래요?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 12),
              ],
            ),
          ),

          // ----------------------------------------
          // 3) 달력 버튼
          // ----------------------------------------
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/calendar');
              },
              icon: Icon(Icons.calendar_month),
              label: Text("달력"),
            ),
          ),

          // ----------------------------------------
          // 4) 말풍선 버튼 (오늘 질문 수동 호출)
          // ----------------------------------------
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                TodayQuestionDialog.show(context);
              },
              child: Icon(Icons.chat_bubble),
            ),
          ),
        ],
      ),
    );
  }
}
