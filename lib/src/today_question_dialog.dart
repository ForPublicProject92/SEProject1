// lib/src/today_question_dialog.dart
import 'package:flutter/material.dart';
import 'question_repository.dart';
import 'question_list.dart';


class TodayQuestionDialog {
  static void show(BuildContext context) async {
    int index = await QuestionRepository.getQuestionIndex();
    final question = questionList[index];

    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 350),
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
                Text(
                  question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: answerController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "답변을 입력하세요...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await QuestionRepository.saveLastAnswerTime(DateTime.now());
                    await QuestionRepository.saveQuestionIndex(index + 1);

                    Navigator.pop(context);
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
