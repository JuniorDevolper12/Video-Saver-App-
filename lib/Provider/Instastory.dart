import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

Future<List<String>> getStoryDownloadUrls(String storyUrl) async {
  List<String> downloadUrls = [];

  try {
    // 1. Extract Username
    String profileUsername = storyUrl
        .replaceAll('https://www.instagram.com/stories/', '')
        .replaceAll('/', '');

    // 2. Fetch Profile Page Directly
    http.Response response = await http.get(Uri.parse(storyUrl));

    // 3. Check for Privacy
    if (response.body.contains('"is_private": true')) {
      print('Account is private');
      return downloadUrls;
    }

    // 4. Parse HTML for JSON Data
    String patternStart = "{\"config\":{\"csrf_token\"";
    String patternEnd = ",\"frontend_env\":\"prod\"}";
    var document = parse(response.body);
    var jsonDataString = document.text!.substring(
        document.text!.indexOf(patternStart) + patternStart.length,
        document.text!.indexOf(patternEnd));

    // 5. Decode JSON and Extract URLs
    var jsonData = json.decode(jsonDataString);
    for (var item in jsonData['entry_data']['StoriesPage'][0]['graphql']['user']
        ['edge_story_to_highlights']['edges']) {
      for (var node in item['node']['reels']) {
        if (node['is_video']) {
          downloadUrls.add(node['video_resources'][0]['src']);
        } else {
          downloadUrls.add(node['display_resources'][2]['src']);
        }
      }
    }
  } catch (error) {
    print('[getStoryDownloadUrls]: $error');
  }

  return downloadUrls;
}
