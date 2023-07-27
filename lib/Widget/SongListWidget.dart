import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_blu/ViewModel/song_view_model.dart';
import 'package:provider/provider.dart';

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
    Song? currentSong = Provider.of<SongViewModel>(context).song;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: 75,
            height: 75,
            child: Image.network(song.coverUrl),
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
        ),
        if(currentSong != null &&
            currentSong.songId == song.songId)
          Icon(
            Icons.graphic_eq,
            color: Theme.of(context).primaryColor,
          )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Song data = widget.songList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child:
                    InkWell(
                      child: _buildSongItem(data),
                      onTap: () {
                        debugPrint("tap on song ${data.songTitle}");
                        if (data.songId.isNotEmpty) {
                          Provider.of<SongViewModel>(context, listen: false).setSelectedSong(data);
                        }
                      },
                    ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: widget.songList.length,
            ),
          ],
        ),
      );
  }
}
