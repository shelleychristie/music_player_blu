import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/song.dart';

class SongListWidget extends StatefulWidget {
  final List<Song> songList;

  SongListWidget(this.songList);

  @override
  State<StatefulWidget> createState() {
    return _SongListWidgetState();
  }
}

class _SongListWidgetState extends State<SongListWidget> {
  Widget _buildSongItem(Song song) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: 75,
            height: 75,
            child: Image(image: AssetImage(song.cover)),
          ),
        ),
        const SizedBox(width: 5.0),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // song title text
                Text(song.songTitle,
                    style: TextStyle(fontSize: 16.0,),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                const SizedBox(
                  height: 5.0,
                ),
                Text(song.artistName,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                const SizedBox(
                  height: 3.0,
                ),
                Text(song.albumTitle,
                    style: TextStyle(fontSize: 10.0, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          Song data = widget.songList[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child:
              InkWell(
                child: _buildSongItem(data),
                onTap: () {
                  debugPrint("tap on song ${data.songTitle}");
                },
              ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: widget.songList.length,
      )
    ]);
  }
}
