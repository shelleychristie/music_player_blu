import 'package:flutter/material.dart';
import 'package:music_player_blu/ViewModel/song_view_model.dart';
import 'package:provider/provider.dart';
import '../Model/song.dart';
import '../Widget/SongListWidget.dart';
import 'Model/API/api_response.dart';
import 'Widget/PlayerWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
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



  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedTrackID = "";
  String _searchArtist = "";


  void changeSong(String id){
    setState(){
      _selectedTrackID = id;
    }
  }

  void searchArtist(String name){
    setState(){
      _searchArtist = name;
    }
  }
  Widget songsWidget(BuildContext context, ApiResponse apiResponse) {
    List<Song>? songList = apiResponse.data as List<Song>?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
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
        return Center(
          child: Text('Error. Try again'),
        );
      case Status.INITIAL:
      default:
        return Center(
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
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  decoration: InputDecoration(
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
            if(_searchArtist.isNotEmpty) Text(_searchArtist),
            Expanded(child:
                songsWidget(context, apiResponse)
            ),
          ],
        ),
      ),
    );
  }
}
