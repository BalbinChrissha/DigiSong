import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/components/footer.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LyricsScreen extends StatefulWidget {
  final song;
  final player;
  const LyricsScreen({super.key, required this.song, required this.player});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  double _size = 18;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.song['videoId'],
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
   Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Lock to portrait orientation
    ]);
    
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
           // automaticallyImplyLeading: false,
            backgroundColor: red,
            centerTitle: true,
            title: Text(widget.song['title']),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _size++;
                    });
                  },
                  icon: const Icon(Icons.add_circle)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _size--;
                    });
                  },
                  icon: const Icon(Icons.remove_circle))
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Center(
                  child: YoutubePlayer(
                    controller: _controller,

                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                    onReady: () {},
                    onEnded: (_) {},
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('lyrics')
                        .where('songUID', isEqualTo: widget.song.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No Lyrics Yet'));
                      }
            
                      List<ListTile> listTiles = snapshot.data!.docs.map((doc) {
                        List<dynamic> lyricsList = doc['lyricsList'] ?? [];
                        String songUID = doc['songUID'];
            
                        List<ListTile> lyricTiles =
                            lyricsList.map<ListTile>((lyric) {
                          return ListTile(
                            title: Text(
                              lyric,
                              style: TextStyle(fontSize: _size),
                            ),
                          );
                        }).toList();
            
                        return ListTile(
                          subtitle: Column(
                            children: lyricTiles,
                            
                          ),
                        );
                      }).toList();
            
                      return ListView(
                      
                        physics: AlwaysScrollableScrollPhysics(),
                        children: listTiles,
                      );
                    },
                  ),
                ),
                FooterPlayer(player: widget.player),
              ],
            ),
          ),
        );
      }
    );
  }
}
