import 'package:flutter/material.dart';

String toLimitedLength(String string, int limit) {
  return string?.substring(0, string.length > limit ? limit : string.length);
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
