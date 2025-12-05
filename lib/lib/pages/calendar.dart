import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../services/api_service.dart';

Future<void> initializeCalendarLocale() async {
  await initializeDateFormatting();
}

class MemberAnswer {
  final String userId;
  final String name;
  final String question;
  final String answer;

  MemberAnswer({
    required this.userId,
    required this.name,
    required this.question,
    required this.answer,
  });

  factory MemberAnswer.fromJson(Map<String, dynamic> json) {
    return MemberAnswer(
      userId: json["user_id"],
      name: json["name"],
      question: json["question"] ?? "",
      answer: json["answer"] ?? "",
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 서버에서 불러온 데이터 저장
  List<MemberAnswer> groupAnswers = [];

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  initializeCalendarLocale();   

  if (_selectedDay != null) {
    _loadDayData(_selectedDay!);
  }
}

  // 날짜 포맷 YYYY-MM-DD 변환
  String formatDate(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-"
      "${d.month.toString().padLeft(2, '0')}-"
      "${d.day.toString().padLeft(2, '0')}";

  // 서버에서 가족 전체 Q/A 데이터 가져오기
  Future<void> _loadDayData(DateTime day) async {
    try {
      final date = formatDate(day);

      final res = await ApiService.get(context, "/api/log/group/$date");

      setState(() {
        groupAnswers =
            (res as List).map((e) => MemberAnswer.fromJson(e)).toList();
      });
    } catch (e) {
      print("캘린더 데이터 로드 실패: $e");
      setState(() {
        groupAnswers = [];
      });
    }
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
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              _loadDayData(selectedDay);
            },

            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() => _calendarFormat = format);
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

    if (groupAnswers.isEmpty) {
      return Center(
        child: Text(
          "이 날에는 저장된 기록이 없어요.",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    // 그룹 전체의 동일한 질문 사용
    final question = groupAnswers.first.question;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Q. $question",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurple[700],
                  ),
                ),

                const Divider(height: 24),

                ...groupAnswers.map((m) => _buildMemberAnswer(m)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberAnswer(MemberAnswer m) {
    final answered = m.answer.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${m.name} 님",
            style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: answered ? Colors.deepPurple[50] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              answered ? m.answer : "(미응답)",
              style: TextStyle(
                fontSize: 15,
                color: answered ? Colors.black87 : Colors.grey[700],
                fontStyle: answered ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
