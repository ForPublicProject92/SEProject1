import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String _pad2(int n) => n.toString().padLeft(2, '0');

Future<String> fetchWeather({int nx = 67, int ny = 101}) async {
  // 저장된 키 불러오기
  final prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('weather_api_key') ?? '';

  // 설정창에 api 입력이 안먹힐경우 사용하는 함수
  // 설정창에 있는 API Key 입력창 비워두셔야 작동합니다
  // API key는 밑 주석에서 발급받아서 하드코딩하여 사용하시면 됩니다.
  // https://www.data.go.kr/data/15084084/openapi.do
  if (key.isEmpty) {
    key = 'api키 입력';
  }

  final now = DateTime.now();
  final baseDate = '${now.year}${_pad2(now.month)}${_pad2(now.day)}';

  // 가장 최근 발표시각 계산
  final hours = [2, 5, 8, 11, 14, 17, 20, 23];
  int baseHour = hours.first;
  for (final h in hours) {
    if (now.hour >= h) baseHour = h;
  }
  final baseTime = '${_pad2(baseHour)}00';

  final uri = Uri.http(
    'apis.data.go.kr',
    '/1360000/VilageFcstInfoService_2.0/getVilageFcst',
    {
      'serviceKey': key,
      'numOfRows': '100',
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
  if (items == null) throw Exception('응답 포맷 오류');

  String value(Map m) => (m['fcstValue'] ?? '').toString();

  final skyItem = items.firstWhere((i) => i['category'] == 'SKY', orElse: () => null);
  final ptyItem = items.firstWhere((i) => i['category'] == 'PTY', orElse: () => null);

  final sky = skyItem != null ? value(skyItem) : '?';
  final pty = ptyItem != null ? value(ptyItem) : '?';

  return '$sky-$pty';
}