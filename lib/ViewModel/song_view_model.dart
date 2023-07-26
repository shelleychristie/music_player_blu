import 'package:flutter/cupertino.dart';

import '../Model/song.dart';

class SongViewModel with ChangeNotifier {
  Song? _song;

  Song? get song {
    return _song;
  }

  void setSelectedSong(Song? song) {
    _song = song;
    notifyListeners();
  }
}