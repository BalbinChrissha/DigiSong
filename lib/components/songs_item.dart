import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/screens/lyrics_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SongItemScreen extends StatefulWidget {
  final song;
  final  player;
  bool isFavorite;
  SongItemScreen({super.key, required this.song, required this.isFavorite, required this.player});

  @override
  State<SongItemScreen> createState() => _SongItemScreenState();
}

class _SongItemScreenState extends State<SongItemScreen> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (() {
      Navigator.push(context, MaterialPageRoute (builder: ((context) => LyricsScreen(song: widget.song, player: widget.player))));
      }),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 50, 49, 49)),
        ),
        child: ListTile(
          tileColor: bg,
          title: Text(
            widget.song['title'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          subtitle: Text(widget.song['singer']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (widget.isFavorite == false) {
                          //  print(FirebaseAuth.instance.currentUser!.uid);
                          await db.collection('favorite').add({
                            'playerID': widget.song['playerID'],
                            'songId': widget.song['songId'],
                            'songUID': widget.song.id,
                            'userId': FirebaseAuth.instance.currentUser!.uid
                          });
                        } else {
                          final QuerySnapshot snapshot = await FirebaseFirestore
                              .instance
                              .collection('favorite')
                              .where('songId', isEqualTo: widget.song['songId'])
                              .where('userId',
                                  isEqualTo:FirebaseAuth.instance.currentUser!.uid)
                              .get();
                          final List<QueryDocumentSnapshot> documents =
                              snapshot.docs;

                          for (final doc in documents) {
                            await doc.reference.delete();
                          }
                        }
                      },
                      icon: Icon(Icons.favorite),
                      color: widget.isFavorite ? Colors.red : Colors.grey),
                  Positioned(
                      bottom: -1,
                      child: Center(
                          child: Text(
                        'Vol ${widget.song['volume']}',
                        style: TextStyle(fontSize: 12),
                      ))),
                ],
              ),
              Container(
                  height: double.infinity,
                  width: 55,
                  color: red,
                  child: Center(
                      child: Text(
                    widget.song['songId'].toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}
