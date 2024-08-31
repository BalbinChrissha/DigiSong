import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/screens/lyrics_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteComponent extends StatelessWidget {
  const FavoriteComponent(
      {super.key, required this.song, required this.player});

  final player;
  final QueryDocumentSnapshot<Object?> song;

  @override
  Widget build(BuildContext context) {
    String Colsongid = song['songUID'];
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('songs')
          .doc(Colsongid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String title = snapshot.data!['title'];
          String singer = snapshot.data!['singer'];
          int volume = snapshot.data!['volume'];
          int songId = snapshot.data!['songId'];

          return GestureDetector(
            onDoubleTap: (() {
              Navigator.push(context, MaterialPageRoute (builder: ((context) => LyricsScreen(song: song, player: player))));
            }),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 50, 49, 49)),
              ),
              child: ListTile(
                tileColor: bg,
                title: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                subtitle: Text(singer),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                            onPressed: () async {
                              final QuerySnapshot snapshot =
                                  await FirebaseFirestore.instance
                                      .collection('favorite')
                                      .where('songId',
                                          isEqualTo: song['songId'])
                                      .where('userId',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .get();
                              final List<QueryDocumentSnapshot> documents =
                                  snapshot.docs;

                              for (final doc in documents) {
                                await doc.reference.delete();
                              }
                            },
                            icon: Icon(Icons.favorite),
                            color: Colors.red),
                        Positioned(
                            bottom: -1,
                            child: Center(
                                child: Text(
                              'Vol ${volume}',
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
                          songId.toString(),
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

        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
