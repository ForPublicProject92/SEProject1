// lib/src/balloon/question_popup.dart
import 'package:flutter/material.dart';
import 'question_repository.dart';
import 'question_list.dart';


class QuestionPopup {
  static Future<void> show(BuildContext context) async {
    int index = await QuestionRepository.getQuestionIndex();
    final question = questionList[index];

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
