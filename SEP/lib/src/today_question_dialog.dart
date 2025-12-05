// lib/src/today_question_dialog.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TodayQuestionDialog {
  static Future<void> show(BuildContext context) async {
    // ------------------------------
    // 1) 서버에서 오늘의 질문 가져오기
    // ------------------------------
    Map<String, dynamic> todayData;

    try {
      todayData = await ApiService.get(context, "/api/question/today");
    } catch (e) {
      return; // 서버 불안정 시 팝업 띄우지 않음
    }

    final question = todayData["question"] ?? "질문을 불러올 수 없습니다.";
    final prevAnswer = todayData["answer"] ?? "";

    TextEditingController answerController =
        TextEditingController(text: prevAnswer);

    // ------------------------------
    // 2) UI 다이얼로그
    // ------------------------------
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 380),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "오늘의 질문",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 20),

                // ------------------------------
                // 질문 표시
                // ------------------------------
                Text(
                  question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 30),

                // ------------------------------
                // 답변 입력창
                // ------------------------------
                TextField(
                  controller: answerController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "답변을 입력하거나 수정하세요...",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------------------
                // 제출 버튼
                // ------------------------------
                ElevatedButton(
                  onPressed: () async {
                    final answerText = answerController.text.trim();

                    try {
                      await ApiService.post(
                        context,
                        "/api/question/answer",
                        {"answer": answerText},
                      );

                      Navigator.pop(context);  
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("답변 저장 실패")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3E5F5),
                  ),
                  child: const Text("답변 제출"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
