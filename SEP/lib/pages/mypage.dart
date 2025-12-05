// mypage.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../src/auth/local_storage.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool loading = true;

  String userId = "";
  String name = "";
  String phone = "";
  String? familyCode;

  // 수정용 컨트롤러
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // 비밀번호 변경용 컨트롤러
  final currentPwCtrl = TextEditingController();
  final newPwCtrl = TextEditingController();
  final newPwCheckCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final res = await ApiService.get(context, "/api/info/me");

      setState(() {
        userId = res["_id"] ?? "";    
        name = res["name"] ?? "";
        phone = res["phone"] ?? "";
        familyCode = res["family_code"]?.toString();

        nameCtrl.text = name;
        phoneCtrl.text = phone;

        loading = false;
      });
    } catch (e) {
      print("유저 정보 로드 실패: $e");
      setState(() => loading = false);
    }
  }

  Future<void> _updateInfo() async {
    try {
      final res = await ApiService.post(
        context,
        "/api/info/update",
        {
          "name": nameCtrl.text,
          "phone": phoneCtrl.text,
        },
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("수정 완료")));

      setState(() {
        name = nameCtrl.text;
        phone = phoneCtrl.text;
      });

      Navigator.pop(context, true);
    } catch (e) {
      print("정보 수정 실패: $e");
    }
  }

  Future<void> _changePassword() async {
    if (newPwCtrl.text != newPwCheckCtrl.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("새 비밀번호가 일치하지 않습니다.")));
      return;
    }

    try {
      final res = await ApiService.post(
        context,
        "/api/auth/change-password",
        {
          "current": currentPwCtrl.text,
          "new": newPwCtrl.text,
        },
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("비밀번호 변경 완료")));

      Navigator.pop(context);
    } catch (e) {
      print("비밀번호 변경 실패: $e");
    }
  }

  Future<void> _deleteAccount() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("회원 탈퇴"),
          content: const Text("정말 탈퇴하시겠습니까?\n가족 그룹에서도 자동으로 제거됩니다."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("취소")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("탈퇴")),
          ],
        );
      },
    );

    if (ok != true) return;

    try {
      await ApiService.post(context, "/api/auth/delete-account", {});
      await LocalAuthStorage.clear();

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
        (route) => false,
      );
    } catch (e) {
      print("회원 탈퇴 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("마이페이지"),
        backgroundColor: const Color(0xFFB695C0),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          _infoTile("아이디", userId),
          _infoTile("이름", name),
          _infoTile("전화번호", phone),
          _infoTile("가족 코드", familyCode?.toString() ?? "없음"),

          const SizedBox(height: 20),
          const Divider(),

          // 정보 수정 버튼
          ElevatedButton(
            onPressed: () => _showEditInfoDialog(context),
            child: const Text("정보 수정"),
          ),

          const SizedBox(height: 10),

          // 비밀번호 변경 버튼
          ElevatedButton(
            onPressed: () => _showChangePasswordDialog(context),
            child: const Text("비밀번호 변경"),
          ),

          const SizedBox(height: 20),
          const Divider(),

          // 회원 탈퇴 버튼
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: _deleteAccount,
            child: const Text("회원 탈퇴"),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // ---------- 정보 수정 팝업 ----------
  void _showEditInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("정보 수정"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "이름")),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "전화번호")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("취소")),
          TextButton(onPressed: _updateInfo, child: const Text("저장")),
        ],
      ),
    );
  }

  // ---------- 비밀번호 변경 팝업 ----------
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("비밀번호 변경"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPwCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "현재 비밀번호"),
            ),
            TextField(
              controller: newPwCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "새 비밀번호"),
            ),
            TextField(
              controller: newPwCheckCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "새 비밀번호 확인"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("취소")),
          TextButton(onPressed: _changePassword, child: const Text("변경")),
        ],
      ),
    );
  }
}
