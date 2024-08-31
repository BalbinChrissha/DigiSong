import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/components/favorite_component.dart';
import 'package:digisong_etr/components/footer.dart';
import 'package:digisong_etr/components/songs_item.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/models/category.dart';
import 'package:digisong_etr/screens/category_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FilteredCategoryScreen extends StatelessWidget {
  final Category category;
  final player;
  const FilteredCategoryScreen(
      {super.key, required this.category, required this.player});

  @override
  Widget build(BuildContext context) {
    var songStream;
    if (category.categoryid == 11) {
      songStream = FirebaseFirestore.instance
          .collection('songs')
          .where('playerID', isEqualTo: player['playerID'])
          .orderBy('songId', descending: true)
          .snapshots();
    } else if (category.categoryid == 12) {
      songStream = FirebaseFirestore.instance
          .collection('favorite')
          .where('playerID', isEqualTo: player['playerID'])
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('songId', descending: false)
          .snapshots();
    } else {
      songStream = FirebaseFirestore.instance
          .collection('songs')
          .where('playerID', isEqualTo: player['playerID'])
          .where('catid',
              isEqualTo: category.categoryid) // Add the new where condition
          .orderBy('title', descending: false)
          .snapshots();
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Column(
            children: [
              Container(
                color: backColor,
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(player: player),));
                        },
                        icon: const Icon(
                          // <-- Icon
                          Icons.search,
                          size: 24.0,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red, // Background color
                          foregroundColor:
                              Colors.white, // Text Color (Foreground color)
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
                                      ))));
                        },
                        icon: const Icon(
                          // <-- Icon
                          Icons.audiotrack,
                          size: 24.0,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red, // Background color
                          foregroundColor:
                              Colors.white, // Text Color (Foreground color)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        label:
                            const Text('Genre', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category.catdesc,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              )
            ],
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
                  if (!snapshot.hasData ||
                      (snapshot.data as QuerySnapshot).docs.isEmpty) {
                    return Text('No data available');
                  }
                  if (snapshot.hasData) {
                    var documents = (snapshot.data as QuerySnapshot).docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var song = documents[index];
                        return category.categoryid == 12
                            ? FavoriteComponent(song: song, player: player)
                            : GenreComponent(song: song, player: player);
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
          FooterPlayer(player: player)
        ],
      )),
    );
  }
}

class GenreComponent extends StatelessWidget {
  const GenreComponent({super.key, required this.song, required this.player});

  final player;
  final QueryDocumentSnapshot<Object?> song;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('favorite')
          .where('songId', isEqualTo: song['songId'])
          .where('userId',
              isEqualTo: FirebaseAuth.instance.currentUser!
                  .uid) // Add this line to filter by current user ID
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          // Document found in 'favorite' collection
          return SongItemScreen(
            song: song,
            isFavorite: true,
            player: player,
          );
        } else {
          // Document not found in 'favorite' collection
          return SongItemScreen(
            song: song,
            isFavorite: false,
            player: player,
          );
        }
      },
    );
  }
}
