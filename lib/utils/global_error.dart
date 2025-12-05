import 'package:flutter/material.dart';

class GlobalError {
  static void showServerError(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("서버 오류"),
          content: const Text("서버가 불안정합니다.\n잠시 후 다시 시도해주세요."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기

                // 모든 페이지 제거 후 StartPage로 이동
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/start',
                  (route) => false,
                );
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }
}
