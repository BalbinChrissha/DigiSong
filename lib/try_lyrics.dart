import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LyricsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lyrics List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('lyrics')
            .where('songUID', isEqualTo: '2kvOGWGxTUuPaijilGi8')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No data');
          }

          List<ListTile> listTiles = snapshot.data!.docs.map((doc) {
            List<dynamic> lyricsList = doc['lyricsList'] ?? [];
            String songUID = doc['songUID'];

            List<ListTile> lyricTiles = lyricsList.map<ListTile>((lyric) {
              return ListTile(
                title: Text(lyric),
              );
            }).toList();

            return ListTile(
              title: Text(songUID),
              subtitle: Column(
                children: lyricTiles,
              ),
            );
          }).toList();

          return ListView(
            children: listTiles,
          );
        },
      ),
    );
  }
}
