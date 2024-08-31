import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/components/footer.dart';
import 'package:digisong_etr/components/songs_item.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/screens/category_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final player;
  const SearchScreen({super.key, required this.player});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

const List<String> list = <String>['Title', 'Artist'];

class _SearchScreenState extends State<SearchScreen> {
  String keyword = '';

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Column(
            children: [
              Container(
                color: backColor,
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 35.5,
                      decoration: BoxDecoration(
                        color: red,
                        border: Border.all(color: Colors.red),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            dropdownColor: red,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: 24,
                            ),
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            underline: const SizedBox(),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                              //print(dropdownValue);
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )),
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
                                        player: widget.player,
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
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(13),
                child: TextField(
                    // controller: controller,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: dropdownValue,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black))),
                    onChanged: (value) {
                      setState(() {
                        keyword = value;
                      });
                      keyword = value;
                    }),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: StreamBuilder(
                stream: dropdownValue == 'Title'
                    ? FirebaseFirestore.instance
                        .collection('songs')
                        .where('playerID', isEqualTo: widget.player['playerID'])
                        .orderBy('title')
                        .startAt([keyword]).endAt(
                            [keyword + '\uf8ff']).snapshots()
                    : 
                       FirebaseFirestore.instance
                        .collection('songs')
                        .where('playerID', isEqualTo: widget.player['playerID'])
                        .orderBy('singer')
                        .startAt([keyword]).endAt(
                            [keyword + '\uf8ff']).snapshots(),
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
                                  isEqualTo: FirebaseAuth.instance.currentUser!
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
                                  player: widget.player);
                            } else {
                              // Document not found in 'favorite' collection
                              return SongItemScreen(
                                  song: song,
                                  isFavorite: false,
                                  player: widget.player);
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
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(12),
          //     child: FutureBuilder(
          //         future: Provider.of<Songs>(context).fetchFromDb(),
          //         builder: (context, snapshot) {
          //           return snapshot.connectionState == ConnectionState.waiting
          //               ? const Center(child: CircularProgressIndicator())
          //               : Consumer<Songs>(
          //                   builder: (context, value, child) {
          //                     final SongList = value.searchkey(
          //                         widget.player.playerid,
          //                         keyword,
          //                         dropdownValue);
          //                     return ListView.builder(
          //                       itemBuilder: (context, index) =>
          //                           ChangeNotifierProvider.value(
          //                         value: SongList[index],
          //                         child: const SongItemSceen(),
          //                       ),
          //                       itemCount: SongList.length,
          //                     );
          //                   },
          //                 );
          //         }),
          //   ),
          // ),
          FooterPlayer(player: widget.player),
        ],
      )),
    );
  }
}
