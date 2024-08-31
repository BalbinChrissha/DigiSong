import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/admin_Screens/song_update.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:flutter/material.dart';

class SongListTile extends StatefulWidget {
  final song;
  SongListTile({super.key, required this.song});

  @override
  State<SongListTile> createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: bg,
        leading: Text(
          widget.song['songId'].toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        title: Text(
          widget.song['title'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        subtitle: Text('Player ${widget.song['playerID']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateSongScreen(song: widget.song),
                    ));
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.amber,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete'),
                        content: Text(
                            'You are about to delete ${widget.song['title']}. Are you sure?'),
                        actions: [
                          ElevatedButton(
                              onPressed: () async {
                                await db
                                    .collection('songs')
                                    .doc(widget.song.id)
                                    .delete();
                                Navigator.of(context).pop();
                              },
                              child: const Text('YES')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'))
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
