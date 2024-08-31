import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:flutter/material.dart';

class PLayerListTile extends StatefulWidget {
  final player;
  PLayerListTile({super.key, required this.player});

  @override
  State<PLayerListTile> createState() => _PLayerListTileState();
}

class _PLayerListTileState extends State<PLayerListTile> {
  final db = FirebaseFirestore.instance;
  var playertitleController = TextEditingController();

  void edit(String id) async {
    await db
        .collection('players')
        .doc(id)
        .update({'playertitle': playertitleController.text});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: bg,
        leading: Text(
          widget.player['playerID'].toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        title: Text(
          widget.player['playertitle'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit Lyric'),
                      content: TextField(
                        style: inputTextSize,
                        minLines: 2,
                        maxLines: 3,
                        controller: playertitleController
                          ..text = widget.player['playertitle'],
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
                             edit(widget.player.id);
                            Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
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
                            'You are about to delete ${widget.player['playertitle']}. Are you sure?'),
                        actions: [
                          ElevatedButton(
                              onPressed: () async {
                                await db
                                    .collection('players')
                                    .doc(widget.player.id)
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
