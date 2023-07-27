class Song {
  final String songId;
  final String songTitle;
  final String coverUrl; // the link to the cover art
  final String albumTitle;
  final String artistName;
  final String songMedia; // the link to the mp3

  Song(
      {required this.songId,
      required this.songTitle,
      required this.coverUrl,
      required this.albumTitle,
      required this.artistName,
      required this.songMedia});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      songId: json['trackId'].toString() as String,
      songTitle: json['trackName'] as String,
      artistName: json['artistName'] as String,
      albumTitle: json['collectionName'] as String,
      coverUrl: json['artworkUrl100'] as String,
      songMedia: json['previewUrl'] as String,
    );
  }
}
