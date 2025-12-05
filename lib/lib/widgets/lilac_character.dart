import 'package:flutter/material.dart';

/// 라일락 캐릭터 (답변한 일수에 따라 3단계 성장)
class LilacCharacter extends StatelessWidget {
  final int answeredDaysCount;

  const LilacCharacter({
    super.key,
    required this.answeredDaysCount,
  });

  // 몇 단계인지 계산 (지금은 테스트용 그대로 둠)
  int get stage {
    if (answeredDaysCount >= 10) return 3; // 3단계
    if (answeredDaysCount >= 5) return 2;  // 2단계
    return 1;                              // 1단계
  }

  // 이미지 경로 (assets 폴더 바로 아래라고 가정)
  String get imagePath {
    switch (stage) {
      case 1:
        return "assets/lilac_1.png";
      case 2:
        return "assets/lilac_2.png";
      case 3:
        return "assets/lilac_3.png";
      default:
        return "assets/lilac_1.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}
