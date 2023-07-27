import 'package:flutter/cupertino.dart';
import '../Model/API/api_response.dart';

import '../Model/song.dart';
import '../Model/song_repository.dart';

class SongViewModel with ChangeNotifier {
  Song? _song;
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  Song? get song {
    return _song;
  }

  ApiResponse get response {
    return _apiResponse;
  }

  Future fetchData(String value) async {
    _apiResponse = ApiResponse.loading('Fetching data');
    notifyListeners();
    try {
      List<Song> mediaList = await SongRepository().fetchSongList(value);
      _apiResponse = ApiResponse.completed(mediaList);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  void setSelectedSong(Song? song) {
    _song = song;
    notifyListeners();
  }
}