// lib/src/balloon/question_popup.dart
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class QuestionPopup {
  static Future<void> show(BuildContext context) async {
    // -----------------------------
    // 1) 서버에서 오늘 질문 가져오기
    // -----------------------------
    Map<String, dynamic> todayData;

    try {
      todayData = await ApiService.get(context, "/api/question/today");
    } catch (e) {
      // 서버 오류 시 팝업 대신 에러 표시
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("질문을 불러올 수 없습니다.")));
      return;
    }

    final question = todayData["question"] ?? "질문을 불러올 수 없습니다.";

    // -----------------------------
    // 2) 팝업 다이얼로그 표시
    // -----------------------------
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "오늘의 질문",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  question,
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("확인"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
