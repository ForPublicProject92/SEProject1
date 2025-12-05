import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FamilyAddPage extends StatefulWidget {
  const FamilyAddPage({super.key});

  @override
  State<FamilyAddPage> createState() => _FamilyAddPageState();
}

class _FamilyAddPageState extends State<FamilyAddPage> {
  final phoneCtrl = TextEditingController();
  Map<String, dynamic>? targetUser;

  bool loadingSearch = false;
  bool loadingInvite = false;

  Future<void> _searchUser() async {
    setState(() => loadingSearch = true);
    final phone = phoneCtrl.text.trim();

    try {
      final res =
          await ApiService.get(context, "/api/family/search/$phone");

      setState(() {
        targetUser = res;
        loadingSearch = false;
      });
    } catch (e) {
      setState(() {
        loadingSearch = false;
        targetUser = null;
      });
      _showMsg("사용자를 찾을 수 없습니다");
    }
  }

  Future<void> _sendInvite() async {
    if (targetUser == null) return;

    setState(() => loadingInvite = true);

    try {
      await ApiService.post(context, "/api/family/invite", {
        "target_id": targetUser!["_id"],
      });

      setState(() => loadingInvite = false);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("초대 완료"),
          content: Text("${targetUser!["name"]}님에게 가족 초대를 보냈습니다."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인"))
          ],
        ),
      );
    } catch (e) {
      setState(() => loadingInvite = false);
      _showMsg("초대 실패: $e");
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("가족 추가하기"),
        backgroundColor: const Color(0xFFB695C0),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("가족으로 추가할 사람의 전화번호를 입력하세요"),

            const SizedBox(height: 20),

            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(
                labelText: "전화번호",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loadingSearch ? null : _searchUser,
              child: loadingSearch
                  ? const CircularProgressIndicator()
                  : const Text("검색"),
            ),

            const SizedBox(height: 20),

            if (targetUser != null) _buildSearchResult()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResult() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(targetUser!["name"], style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            Text(targetUser!["phone"]),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loadingInvite ? null : _sendInvite,
              child: loadingInvite
                  ? const CircularProgressIndicator()
                  : const Text("가족 초대 보내기"),
            ),
          ],
        ),
      ),
    );
  }
}
