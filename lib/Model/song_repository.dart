import 'dart:developer';

import 'package:music_player_blu/Model/API/api_service.dart';
import 'package:music_player_blu/Model/song.dart';

class SongRepository {
  ApiService _apiService = ApiService();

  Future<List<Song>> fetchSongList(String value) async {
    log("fetch: $value");
  dynamic response = await _apiService.getResponse(value);
  final jsonData = response['results'] as List;
  List<Song> songList =
  jsonData.map((tagJson) => Song.fromJson(tagJson)).toList();
  return songList;
  }

}