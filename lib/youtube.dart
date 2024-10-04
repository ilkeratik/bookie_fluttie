import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class YouTubeThumbnailFetcher {
  final String apiKey;

  YouTubeThumbnailFetcher(this.apiKey);

  Future<Map<String, dynamic>?> fetchVideoDetails(String videoId) async {
    final url =
        'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          return data['items'][0]['snippet'];
        }
      } else {
        debugPrint('Failed to load video data');
      }
    } catch (e) {
      debugPrint('Error fetching video data: $e');
    }
    return null;
  }
}
