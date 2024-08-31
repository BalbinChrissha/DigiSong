import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:flutter/material.dart';

class ManageLyricsScreen extends StatefulWidget {
  final song;

  const ManageLyricsScreen({Key? key, required this.song}) : super(key: key);

  @override
  State<ManageLyricsScreen> createState() => _ManageLyricsScreenState();
}

class _ManageLyricsScreenState extends State<ManageLyricsScreen> {
  var lyricsUID;
  var addlyricController = TextEditingController();
  var check = 1;

  Future<void> updateLyric(
      int index, String newLyric, String collectionLyricId) async {
    try {
      final lyricsRef = FirebaseFirestore.instance
          .collection('lyrics')
          .doc(collectionLyricId);

      final doc = await lyricsRef.get();
      List<dynamic> lyricsList = doc.data()?['lyricsList'];

      // Update the lyric at the specified index
      lyricsList[index] = newLyric;

      // Update the entire array in Firestore
      await lyricsRef.update({
        'lyricsList': lyricsList,
      });
    } catch (error) {
      print('Error updating lyric: $error');
    }
  }

  Future<void> deleteLyric(int index, String collectionLyricId) async {
    if (index == 0) {
      await FirebaseFirestore.instance
          .collection('lyrics')
          .doc(collectionLyricId)
          .delete();
    } else {
      final lyricsRef = FirebaseFirestore.instance
          .collection('lyrics')
          .doc(collectionLyricId);

      // Get the current array of lyrics
      final doc = await lyricsRef.get();
      List<dynamic> lyricsList = doc.data()?['lyricsList'];

      // Remove the lyric at the specified index
      lyricsList.removeAt(index);

      // Update array
      await lyricsRef.update({
        'lyricsList': lyricsList,
      });

      print('Lyric deleted successfully');
    }
  }

  Future<void> addLyric(String collectionLyricId) async {
    try {
      final lyricsRef = FirebaseFirestore.instance
          .collection('lyrics')
          .doc(collectionLyricId);

      // Get the current array of lyrics
      final doc = await lyricsRef.get();
      List<dynamic> lyricsList = doc.data()?['lyricsList'];

      // Add the new lyric to the array
      lyricsList.add(addlyricController.text);

      // Update array
      await lyricsRef.update({
        'lyricsList': lyricsList,
      });

      print('Lyric added successfully');
    } catch (error) {
      print('Error adding lyric: $error');
    }

    setState(() {
      addlyricController.clear();
    });
  }

  Future<void> addfirstLyric(String songUID) async {
    try {
      final lyricsCollection = FirebaseFirestore.instance.collection('lyrics');

      await lyricsCollection.add({
        'songUID': songUID,
        'lyricsList': [addlyricController.text],
      });

      print('Lyric document created successfully');
    } catch (error) {
      print('Error creating lyric document: $error');
    }

    setState(() {
      addlyricController.clear();
      check = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(widget.song['title']),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('lyrics')
                    .where('songUID', isEqualTo: widget.song.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    check = 0;
                    return Center(child: Text('No Lyrics Yet'));
                  }

                  DocumentSnapshot<Object?> lyricDocument =
                      snapshot.data!.docs[0];
                  String lyricId = lyricDocument.id;
                  lyricsUID = lyricId;
                  List<ListTile> listTiles =
                      snapshot.data!.docs.asMap().entries.map((entry) {
                    int index = entry.key;
                    DocumentSnapshot<Object?> doc = entry.value;
                    List<dynamic> lyricsList = doc['lyricsList'] ?? [];

                    List<ListTile> lyricTiles =
                        lyricsList.asMap().entries.map((entry) {
                      int lyricIndex = entry.key;
                      dynamic lyric = entry.value;
                      var totalind = lyricIndex + 1;

                      return ListTile(
                        title: Text(
                          'Lyric $totalind : $lyric',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String currentLyric =
                                        lyricsList[lyricIndex];

                                    return AlertDialog(
                                      title: Text('Edit Lyric'),
                                      content: TextField(
                                        minLines: 5,
                                        maxLines: 10,
                                        controller: TextEditingController(
                                            text: currentLyric),
                                        onChanged: (value) {
                                          currentLyric = value;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            updateLyric(lyricIndex,
                                                currentLyric, lyricId);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteLyric(lyricIndex, lyricId);
                              },
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.red,
                              ),
                            )
                          ],
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Lyric'),
                content: TextField(
                  decoration: InputDecoration(hintText: 'Enter Lyric'),
                  style: inputTextSize,
                  minLines: 5,
                  maxLines: 10,
                  controller: addlyricController,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        addlyricController.clear();
                      });
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (check == 0) {
                        addfirstLyric(widget.song.id);
                      } else {
                        addLyric(lyricsUID);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Color.fromARGB(255, 171, 78, 15),
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
    );
  }
}
