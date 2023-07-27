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

  @override
  Widget build(BuildContext context) {
    Song? currentSong = Provider.of<SongViewModel>(context).song;
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          CircleAvatar(
              radius: 25.0,
              child: IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 25.0,
                  onPressed: () async {
                    if (isPlaying) {
                      // debugPrint("isPlaying");
                      await audioplayer.pause();
                      // isPlaying = false;
                    } else {
                      // var url = Uri.parse(currentSong!.songMedia);
                      await audioplayer.play(UrlSource(currentSong!.songMedia),
                          position: position);
                      // isPlaying = true;
                    }
                  })),
          Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioplayer.seek(position);
                // await audioplayer.resume();
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
