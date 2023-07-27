import 'package:flutter/material.dart';
import 'package:music_player_blu/ViewModel/song_view_model.dart';
import 'package:provider/provider.dart';
import '../Model/song.dart';
import '../Widget/song_list_widget.dart';
import 'Model/API/api_response.dart';
import 'Widget/player_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SongViewModel()),
      ],
      child:
        MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Music Player'),
        ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget songsWidget(BuildContext context, ApiResponse apiResponse) {
    List<Song>? songList = apiResponse.data as List<Song>?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return const Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 8,
              child: SongListWidget(songList!),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: PlayerWidget(
                ),
              ),
            ),
          ],
        );
      case Status.ERROR:
        return const Center(
          child: Text('Error. Try again'),
        );
      case Status.INITIAL:
      default:
        return const Center(
          child: Text('Search by artist'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _inputController = TextEditingController();
    ApiResponse apiResponse = Provider.of<SongViewModel>(context).response;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    fillColor: Colors.white60,
                    filled: true,
                    hintText: "Search artist",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  controller: _inputController,
                  onChanged: (value){},
                  onFieldSubmitted: (value){
                    if(value.isNotEmpty){
                      Provider.of<SongViewModel>(context, listen: false)
                          .setSelectedSong(null);
                      Provider.of<SongViewModel>(context, listen: false)
                          .fetchData(value);
                    }
                  },
                )),
            Expanded(child:
                songsWidget(context, apiResponse)
            ),
          ],
        ),
      ),
    );
  }
}
