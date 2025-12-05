import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String _pad2(int n) => n.toString().padLeft(2, '0');

Future<String> fetchWeather({int nx = 67, int ny = 101}) async {
  // 저장된 키 불러오기
  final prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('weather_api_key') ?? '';

  // 설정창 입력 안될 때 하드코딩 키 사용
  if (key.isEmpty) {
    key = 'b953db0f60a91cc494ed78e6ccae0420e680a955780c1989941d5c5710ef4f19';
  }

  // 공공데이터포털 키는 반드시 URL 디코딩해야 함
  key = Uri.decodeComponent(key);

  // 현재 시각
  DateTime now = DateTime.now();
  DateTime base = now;

  // 단기예보 발표시각 리스트
  final hours = [2, 5, 8, 11, 14, 17, 20, 23];
  int baseHour = hours.first;

  for (final h in hours) {
    if (now.hour >= h) baseHour = h;
  }

  // 00~01시는 어제 23시 발표를 사용해야 API가 오류 없이 동작함
  if (now.hour < 2) {
    base = now.subtract(Duration(days: 1));
    baseHour = 23;
  }

  final baseDate = '${base.year}${_pad2(base.month)}${_pad2(base.day)}';
  final baseTime = '${_pad2(baseHour)}00';

  final uri = Uri.https(
    'apis.data.go.kr',
    '/1360000/VilageFcstInfoService_2.0/getVilageFcst',
    {
      'serviceKey': key,
      'numOfRows': '200',
      'pageNo': '1',
      'dataType': 'JSON',
      'base_date': baseDate,
      'base_time': baseTime,
      'nx': nx.toString(),
      'ny': ny.toString(),
    },
  );
  final res = await http.get(uri);
  if (res.statusCode != 200) {
    throw Exception('날씨 API 호출 실패: ${res.statusCode}');
  }

  final body = jsonDecode(res.body);

  final items = body['response']?['body']?['items']?['item'];
  if (items == null) {
    throw Exception('응답 포맷 오류 — API 키 또는 날짜/시간 불일치');
  }

  // 값 가져오기
  String value(Map m) => (m['fcstValue'] ?? '').toString();

  final skyItem = items.firstWhere((i) => i['category'] == 'SKY', orElse: () => null);
  final ptyItem = items.firstWhere((i) => i['category'] == 'PTY', orElse: () => null);

  final sky = skyItem != null ? value(skyItem) : '?';
  final pty = ptyItem != null ? value(ptyItem) : '?';

  return '$sky-$pty';
}
