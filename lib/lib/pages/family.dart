// pages/family.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  Map<String, dynamic>? family;
  List<dynamic> pendingInvites = [];

  @override
  void initState() {
    super.initState();
    _loadFamilyStatus();
  }

Future<void> _loadFamilyStatus() async {
  try {
    // 내 정보
    final me = await ApiService.get(context, "/api/info/me");
    final familyCode = me["family_code"];

    // 초대 목록 조회
    final invites = await ApiService.get(context, "/api/family/invites");
    setState(() => pendingInvites = invites);

    // 가족 없음
    if (familyCode == null) {
      setState(() => family = null);
      return;
    }

    // 그룹 정보 가져오기 — 반드시 /me 사용
    final data = await ApiService.get(context, "/api/family/me");

    setState(() => family = data);

  } catch (e) {
    print("가족 정보 불러오기 실패: $e");
    setState(() => family = null);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("가족 정보"),
        backgroundColor: const Color(0xFFB695C0),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/family/add"),
        backgroundColor: const Color(0xFFB695C0),
        child: const Icon(Icons.group_add),
      ),

      body: _buildBody(),
    );
  }

  // -------------------------------
  // 가족 페이지의 본문 상태 결정
  // -------------------------------
  Widget _buildBody() {
    // 1) 초대받은 상태
    if (pendingInvites.isNotEmpty) {
      return _buildInviteBox(pendingInvites.first);
    }

    // 2) 가족 없음
    if (family == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("아직 가족이 설정되지 않았습니다."),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/family/add"),
              child: const Text("가족 추가하기"),
            ),
          ],
        ),
      );
    }

    // 3) 가족 있음
    return _buildFamilyList();
  }

  // -------------------------------
  // 가족 초대 UI
  // -------------------------------
  Widget _buildInviteBox(dynamic invite) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("가족 초대를 받았습니다!", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text("초대한 사람 ID: ${invite["from"]}"),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _acceptInvite,
                    child: const Text("가족 맞아요"),
                  ),
                  OutlinedButton(
                    onPressed: _denyInvite,
                    child: const Text("누구세요?"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _acceptInvite() async {
    final invite = pendingInvites.first;

    await ApiService.post(context, "/api/family/accept", {
      "family_code": invite["family_code"]
    });

    _loadFamilyStatus();
  }

  Future<void> _denyInvite() async {
    final invite = pendingInvites.first;
    await ApiService.post(context, "/api/family/deny", {
      "family_code": invite["family_code"]
    });

    _loadFamilyStatus();
  }

  // -------------------------------
  // 가족 구성원 목록
  // -------------------------------
  Widget _buildFamilyList() {
    final members = family!["members"] as List;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "가족 구성원",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        ...members.map((m) => ListTile(
              leading: const Icon(Icons.person),
              title: Text(m["name"]),
              subtitle: Text(m["phone"]),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => _leaveFamilyDialog(),
              ),
            )),
      ],
    );
  }

  Future<void> _leaveFamilyDialog() async {
    final ok = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("가족 그룹에서 나가기"),
        content: const Text("정말로 가족에서 나가시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("취소")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("나가기")),
        ],
      ),
    );

    if (ok == true) {
      await ApiService.post(context, "/api/family/leave", {});
      _loadFamilyStatus();
    }
  }
}

