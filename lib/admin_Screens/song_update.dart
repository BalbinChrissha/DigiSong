import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/admin_Screens/manage_lyrics_screen.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/models/category_dropdown.dart';
import 'package:flutter/material.dart';


class UpdateSongScreen extends StatefulWidget {
  final song;
  const UpdateSongScreen({super.key, required this.song});

  @override
  State<UpdateSongScreen> createState() => _UpdateSongScreenState();
}

class _UpdateSongScreenState extends State<UpdateSongScreen> {
  final _formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var singerController = TextEditingController();
  var playeridController = TextEditingController();
  var catidController = TextEditingController();
  var volumeController = TextEditingController();
  var videoidController = TextEditingController();

  int playid = 1;
  int cateid = 1;

  String? selectedPlayer;
  List<DropdownMenuItem<String>> PlayerList = [];

  CatDropdown? selectedCategory;
  List<CatDropdown> CategoryList = [
    CatDropdown(catid: 1, cattitle: 'Gospel'),
    CatDropdown(catid: 2, cattitle: 'Pop'),
    CatDropdown(catid: 3, cattitle: 'Jazz'),
    CatDropdown(catid: 4, cattitle: 'Rock'),
    CatDropdown(catid: 5, cattitle: 'Children Songs'),
    CatDropdown(catid: 6, cattitle: 'Original Pilipino Music'),
  ];
  CatDropdown defaultCat = CatDropdown(catid: -1, cattitle: 'None');

  @override
  void initState() {
    super.initState();
    playid = widget.song['playerID'];
    cateid = widget.song['catid'];

    fetchDropdownData().then((_) {
      setState(() {
        selectedPlayer = PlayerList.firstWhere(
          (play) => play.value == playid.toString(),
          orElse: () =>
              PlayerList.first, // Set default value if player ID is not found
        ).value;
      });
    });
    selectedCategory = CategoryList.firstWhere((cat) => cat.catid == cateid);
  }

  Future<void> fetchDropdownData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('players').get();

    List<DropdownMenuItem<String>> items = querySnapshot.docs.map((doc) {
      final String playertitle = doc['playertitle'] as String;
      final int playerID = doc['playerID'] as int;
      return DropdownMenuItem<String>(
        value: playerID.toString(),
        child: Text(playertitle),
      );
    }).toList();

    setState(() {
      PlayerList = items;
      selectedPlayer = PlayerList.isNotEmpty
          ? PlayerList[0].value
          : null; // Set the initial selected value to null
    });
  }

  void updateSong(String id) async {
    String capitalized = (titleController.text).substring(0, 1).toUpperCase() +
        (titleController.text).substring(1);

    await FirebaseFirestore.instance
      ..collection('songs').doc(id).update({
        'title': capitalized,
        'singer': singerController.text,
        'playerID': int.parse(selectedPlayer!),
        'videoId': videoidController.text,
        'volume': int.parse(volumeController.text),
        'catid': cateid,
      });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: Text(widget.song['title']),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ManageLyricsScreen(song: widget.song,)));
          }, icon: Icon(Icons.edit_note_rounded ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: titleController..text = widget.song['title'],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Title.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: singerController..text = widget.song['singer'],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Artist',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Artist';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Text(
                    'Player: ',
                    style: TextStyle(color: backColor, fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    color: red,
                    child: Center(
                      child: DropdownButton<String>(
                        value: selectedPlayer,
                        dropdownColor: red,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        items: PlayerList,
                        onChanged: (value) {
                          setState(() {
                            selectedPlayer = value;
                            print(selectedPlayer);
                          });
                        },
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Text(
                    'Category: ',
                    style: TextStyle(color: backColor, fontSize: 18),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    color: red,
                    child: Center(
                      child: DropdownButton<CatDropdown>(
                        value: selectedCategory,
                        dropdownColor: red,
                        items: CategoryList.map((CatDropdown category) {
                          return DropdownMenuItem<CatDropdown>(
                            value: category,
                            child: Text(
                              category.cattitle,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          );
                        }).toList(),
                        onChanged: (CatDropdown? catnewValue) {
                          setState(() {
                            selectedCategory = catnewValue;
                          });
                          if (catnewValue != null) cateid = catnewValue.catid;
                        },
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: videoidController..text = widget.song['videoId'],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Youtube Video ID',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Video Id';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: volumeController
                    ..text = widget.song['volume'].toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Volume',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount.';
                    } else if (value.contains(new RegExp(r'^[0-9]+$')) ==
                        false) {
                      return 'Invalid Volume (INTEGER ONLY)';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Add'),
                              content: Text(
                                  'You are about to update ${titleController.text}. Are you sure?'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      updateSong(widget.song.id);
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
                    }
                  },
                  child: const Text(
                    'UPDATE SONG',
                    style: TextStyle(fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 220, 69, 69),
                      padding: EdgeInsets.all(12)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
