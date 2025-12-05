// lib/src/weather/weather_icon.dart
import 'package:flutter/widgets.dart';

Widget sunny({double? size, BoxFit fit = BoxFit.contain}) =>
    Image.asset('assets/sunny.png', width: size, height: size, fit: fit);

Widget rain({double? size, BoxFit fit = BoxFit.contain}) =>
    Image.asset('assets/rain.png', width: size, height: size, fit: fit);

Widget snow({double? size, BoxFit fit = BoxFit.contain}) =>
    Image.asset('assets/snow.png', width: size, height: size, fit: fit);

Widget cloudy({double? size, BoxFit fit = BoxFit.contain}) => 
    Image.asset('assets/cloud.png', width: size, height: size, fit: fit);

Widget overcast({double? size, BoxFit fit = BoxFit.contain}) => 
    Image.asset('assets/overcast.png', width: size, height: size, fit: fit);