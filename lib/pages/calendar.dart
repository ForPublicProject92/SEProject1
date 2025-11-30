import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

// 필요 시만 사용
// import 'main_page.dart';
// import 'record.dart';

// 날짜 초기화는 main.dart의 main()에서 한 번만 실행되면 충분하지만
// 페이지 단위에서도 안전하게 보장하기 위해 추가
Future<void> initializeCalendarLocale() async {
  await initializeDateFormatting();
}

class DailyAnswer {
  final String question;
  final String? parentAnswer;
  final String? childAnswer;
  final DateTime date;

  DailyAnswer({
    required this.question,
    this.parentAnswer,
    this.childAnswer,
    required this.date,
  });
}

// ----------------------------
//     Calendar Page
// ----------------------------
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    initializeCalendarLocale();
    _selectedDay = _focusedDay;
  }

  // 임시 데이터 (예시)
  final Map<DateTime, List<DailyAnswer>> _answers = {
    DateTime.utc(DateTime.now().year, DateTime.now().month, 1): [
      DailyAnswer(
        question: "오늘 기분이 어떠셨나요?",
        parentAnswer: "날씨가 좋아서 기분 좋았단다.",
        childAnswer: "과제 때문에 조금 피곤했어요.",
        date: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
      )
    ],
    DateTime.utc(DateTime.now().year, DateTime.now().month, 4): [
      DailyAnswer(
        question: "요즘 가장 힘이 되는 말은 무엇인가요?",
        parentAnswer: "네가 '사랑해요'라고 해줄 때.",
        childAnswer: null,
        date: DateTime.utc(DateTime.now().year, DateTime.now().month, 4),
      )
    ],
    DateTime.utc(DateTime.now().year, DateTime.now().month, 5): [
      DailyAnswer(
        question: "어릴 적 가장 좋아했던 음식은?",
        parentAnswer: "할머니가 해주시던 잡채.",
        childAnswer: "학교 앞 떡볶이!",
        date: DateTime.utc(DateTime.now().year, DateTime.now().month, 5),
      )
    ],
  };

  List<DailyAnswer> _getAnswersForDay(DateTime day) {
    final dayUtc = DateTime.utc(day.year, day.month, day.day);
    return _answers[dayUtc] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("달력"),
        backgroundColor: const Color(0xFFB695C0),
      ),
      body: Column(
        children: [
          TableCalendar<DailyAnswer>(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getAnswersForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },

            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },

            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16.0),

          Expanded(child: _buildAnswerList()),
        ],
      ),
    );
  }

  Widget _buildAnswerList() {
    if (_selectedDay == null) {
      return const Center(child: Text("날짜를 선택해 주세요."));
    }

    final selectedAnswers = _getAnswersForDay(_selectedDay!);

    if (selectedAnswers.isEmpty) {
      return Center(
        child: Text(
          "이 날에는 작성된 답변이 없어요.",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    final answer = selectedAnswers.first;
    bool parentAnswered =
        answer.parentAnswer != null && answer.parentAnswer!.isNotEmpty;
    bool childAnswered =
        answer.childAnswer != null && answer.childAnswer!.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Q. ${answer.question}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const Divider(height: 24, thickness: 1),

                _buildAnswerView(
                  "부모님 답변",
                  answer.parentAnswer,
                  !parentAnswered && childAnswered,
                ),

                const SizedBox(height: 16),

                _buildAnswerView(
                  "자녀 답변",
                  answer.childAnswer,
                  !childAnswered && parentAnswered,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerView(String title, String? answer, bool isWaiting) {
    bool hasAnswered = answer != null && answer.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: hasAnswered ? Colors.deepPurple[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            hasAnswered
                ? answer!
                : (isWaiting
                    ? "상대방이 답변을 기다리고 있어요!"
                    : "아직 답변을 작성하지 않았어요."),
            style: TextStyle(
              fontSize: 15,
              color: hasAnswered ? Colors.black87 : Colors.grey[700],
              fontStyle: hasAnswered ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
