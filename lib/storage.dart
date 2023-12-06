import 'dart:core';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

const String _aocSessionKey = 'h3xDevtoolsAocSession';
String _getAocInputKey(int year, int day) => 'aoc$year${day.toString().padLeft(2, '0')}_input';

Future<String?> getAdventOfCodeSession() {
  const storage = FlutterSecureStorage();
  return storage.read(key: _aocSessionKey);
}

Future<void> setAdventOfCodeSession(String session) {
  const storage = FlutterSecureStorage();
  return storage.write(key: _aocSessionKey, value: session);
}

String? readAdventOfCodeInput(int year, int day) {
  String key = _getAocInputKey(year, day);
  return prefs.getString(key);
}

Future<void> storeAdventOfCodeInput(int year, int day, String input) {
  String key = _getAocInputKey(year, day);
  return prefs.setString(key, input);
}
