// lib/src/question_repository.dart
import 'package:shared_preferences/shared_preferences.dart';

class QuestionRepository {
  static const _keyLastAnswerTime = "last_answer_time";
  static const _keyQuestionIndex = "question_index";

  /// 마지막 답변 시간을 저장
  static Future<void> saveLastAnswerTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastAnswerTime, time.toIso8601String());
  }

  /// 마지막 답변 시간 가져오기
  static Future<DateTime?> getLastAnswerTime() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_keyLastAnswerTime);
    if (saved == null) return null;
    return DateTime.tryParse(saved);
  }

  /// 질문 번호 저장
  static Future<void> saveQuestionIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyQuestionIndex, index);
  }

  /// 질문 번호 가져오기
  ///
  /// - 아직 오늘 오전 6시 전이면: 이전 질문 유지
  /// - 오늘 6시 이후면: 저장된 index 그대로 사용
  static Future<int> getQuestionIndex() async {
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt(_keyQuestionIndex) ?? 0;

    DateTime? lastAnswer = await getLastAnswerTime();
    if (lastAnswer == null) {
      return index;
    }

    final now = DateTime.now();
    final today6AM = DateTime(now.year, now.month, now.day, 6, 0, 0);

    if (now.isBefore(today6AM)) {
      // 6시 전이면 아직 어제 질문 유지
      return index - 1 < 0 ? 0 : index - 1;
    }

    return index;
  }
}
