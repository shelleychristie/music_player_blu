import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/song.dart';
import '../ViewModel/song_view_model.dart';

class PlayerWidget extends StatefulWidget {
  PlayerWidget();

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final audioplayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String? prevSongId;

  @override
  void initState() {
    audioplayer.onPlayerStateChanged.listen((state) {
      setState(() {
        // if state is playing, then isplaying is true
        isPlaying = state == PlayerState.playing;
      });
    });
    audioplayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    audioplayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioplayer.onPlayerComplete.listen((event) {
      setState(() {
        position = Duration.zero;
        duration = Duration.zero;
        isPlaying = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    audioplayer.dispose();
    super.dispose();
  }

  void _playCurrentSong(Song? song) {
    if (song != null && prevSongId != song.songId) {
      prevSongId = song.songId;
      // we need prevSongId so we're not calling play() every time we build
      // which would result in infinite loop
      // log("song is not null");
      _play(song);
    }
  }

  Future<void> _play(Song song) async {
    // log("play 1");
    log(isPlaying.toString());
    final result = await audioplayer.play(UrlSource(song!.songMedia), position: position);
    // log("play 2");
    // setState(() {
    //   duration = Duration.zero;
    //   position = Duration.zero;
    //   isPlaying = true;
    // });
    // log("play 3");
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Song? currentSong = Provider.of<SongViewModel>(context).song;
    _playCurrentSong(currentSong);
    // log("build player widget");
    // log("position " + position.toString());
    // log("duration " + duration.toString());
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          CircleAvatar(
              radius: 25.0,
              child: IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 25.0,
                  onPressed: () async {
                    if (currentSong == null) {
                      var nullSongSnackBar =
                          const SnackBar(content: Text("No song is selected"));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(nullSongSnackBar);
                    } else if (isPlaying) {
                      // debugPrint("isPlaying");
                      await audioplayer.pause();
                      // isPlaying = false;
                    } else {
                      // var url = Uri.parse(currentSong!.songMedia);
                      _play(currentSong);
                    }
                  })),
          Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioplayer.seek(position);
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration)),
              ],
            ),
          )
        ],
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds);

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
