import 'package:flutter/widgets.dart';
import 'weather_icon.dart';

/// SKY/PTY 값을 받아서 아이콘과 설명을 반환
class WeatherFunction {
  static Map<String, dynamic> funcWeather(String sky, String pty) {
    Widget icon;
    String description;

    if (pty == '3') {
      icon = snow(size: 64);
      description = "눈";
    } else if (pty == '1' || pty == '2' || pty == '4') {    //pty == '1' (비), '2' (진눈깨비), '4' (소나기)
      icon = rain(size: 64);
      description = "비";
    } else {
      if (sky == '1') {
        icon = sunny(size: 64);
        description = "맑음";
      } else if (sky == '3') {
        icon = cloudy(size: 64);
        description = "구름많음";
      } else if (sky == '4') {
        icon = overcast(size: 64);
        description = "흐림";
      } else {
        icon = sunny(size: 64);
        description = "알 수 없음";
      }
    }

    return {
      'icon': icon,
      'description': description,
    };
  }
}