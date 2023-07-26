class Song {
  final String songId;
  final String songTitle;
  final String cover; // the link to the cover art
  final String albumTitle;
  final String artistName;
  final String songMedia; // the link to the mp3

  Song(this.songId, this.songTitle, this.cover, this.albumTitle, this.artistName, this.songMedia);

  static List<Song> songs = [
    Song("id1", "Song A", "assets/coverArts/albumA.jpg", "Album A", "Artist A", "assets/music/08 Earth, Wind & Fire - September.mp3"),
    Song("id2", "Song B", "assets/coverArts/albumB.jpg", "Album B", "Artist B", "assets/music/08 Earth, Wind & Fire - September.mp3"),
    Song("id3", "Song C", "assets/coverArts/albumC.jpg", "Album C", "Artist C", "assets/music/08 Earth, Wind & Fire - September.mp3"),
  ];
}