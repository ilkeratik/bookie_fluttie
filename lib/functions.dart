import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

String? extractYouTubeId(String url) {
  // Regular expression pattern to match YouTube video IDs
  final RegExp regExp = RegExp(
    r'(?:(?:v=|\/|be\/|embed\/)([a-zA-Z0-9_-]{11}))',
    caseSensitive: false,
  );

  // Attempt to find a match in the provided URL
  final Match? match = regExp.firstMatch(url);

  // Return the first capturing group if a match is found, otherwise return null
  return match!.group(1);
}

Future<void> saveItemsToStorage(String prefKey, dynamic items) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(prefKey, json.encode(items));
}

Future<List<Map<String, dynamic>>?> loadItemsFromStorage(String prefKey) async {
  final prefs = await SharedPreferences.getInstance();
  final String? itemsJson = prefs.getString(prefKey);
  if (itemsJson != null) {
    return List<Map<String, dynamic>>.from(json.decode(itemsJson));
  } else {
    return [];
  }
}
