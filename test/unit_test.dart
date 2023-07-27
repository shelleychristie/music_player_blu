import 'package:music_player_blu/Model/API/api_response.dart';
import 'package:music_player_blu/Model/API/api_service.dart';
import 'package:music_player_blu/Model/song.dart';
import 'package:music_player_blu/ViewModel/song_view_model.dart';
import 'package:music_player_blu/Widget/song_list_widget.dart';
import 'package:test/test.dart';

void main() {
  final Song song = Song(
    songId: 'songId',
    songTitle: "songTitle",
    albumTitle: 'albumTitle',
    artistName: 'artistName',
    coverUrl: 'coverUrl',
    songMedia: 'songMedia');
  group('song list widget', () {

    final List<Song> songList = <Song>[song];
    final widget = SongListWidget(songList);
    test('should have song list', () {
      expect(widget.songList, songList);
    });
  });
  group('song view model', () {
    SongViewModel viewModel = SongViewModel();
    test('get song when null', (){
      expect(viewModel.song, null);
    });
    test('set selected song', () {
      viewModel.setSelectedSong(song);
      expect(viewModel.song, song);
    });
    test('fetching data correctly', () async {
      await viewModel.fetchData("Lily Allen");
      expect(viewModel.response.data, isA<List<Song>>());
      expect(viewModel.response.data.length, 50);
    });
    test('fetching data incorrectly', () async {
      await viewModel.fetchData("");
      expect(viewModel.response.data, List.empty());
    });
  });
}