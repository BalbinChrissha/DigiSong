import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/components/footer.dart';
import 'package:digisong_etr/components/songs_item.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/screens/category_screen.dart';
import 'package:digisong_etr/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SongScreen extends StatelessWidget {
  final player;

  SongScreen({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var songStream = FirebaseFirestore.instance
        .collection('songs')
        .where('playerID', isEqualTo: player['playerID'])
        .orderBy('title', descending: false)
        .snapshots();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: backColor,
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => SearchScreen(
                                  player: player,
                                )),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 24.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: red,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      label: const Text(
                        'Search',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => CategoryScreen(
                                  player: player,
                                )),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.audiotrack,
                        size: 24.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: red,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      label: const Text(
                        'Genre',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: StreamBuilder(
                  stream: songStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text('No data available');
                    }
                    if (snapshot.hasData) {
                      var documents = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          var song = documents[index];
                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('favorite')
                                .where('songId', isEqualTo: song['songId'])
                                .where('userId',
                                    isEqualTo: FirebaseAuth
                                        .instance
                                        .currentUser!
                                        .uid) // Add this line to filter by current user ID
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                // Document found in 'favorite' collection
                                return SongItemScreen(
                                    song: song,
                                    isFavorite: true,
                                    player: player);
                              } else {
                                // Document not found in 'favorite' collection
                                return SongItemScreen(
                                    song: song,
                                    isFavorite: false,
                                    player: player);
                              }
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('No data available');
                    }
                  },
                ),
              ),
            ),
            FooterPlayer(player: player),
          ],
        ),
      ),
    );
  }
}
