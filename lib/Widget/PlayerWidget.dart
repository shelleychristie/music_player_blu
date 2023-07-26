import 'dart:convert';
import 'dart:html';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Song? currentSong = Provider.of<SongViewModel>(context).song;
    return Column(
      children: [
        CircleAvatar(
            radius: 10.0,
            child: IconButton(
                icon: Icon(isPlaying ? Icons.play_arrow : Icons.pause),
                iconSize: 35.0,
                onPressed: () async {
                  if (isPlaying) {
                    await audioplayer.pause();
                  } else {
                    Url source = currentSong!.songMedia as Url;
                    await audioplayer.play(source as Source,
                        position: position);
                  }
                })),
        Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {}),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(position)),
              Text(formatTime(duration)),
            ],
          ),
        )
      ],
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
