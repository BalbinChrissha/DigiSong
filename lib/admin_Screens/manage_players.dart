import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/admin_Screens/add_new_song.dart';
import 'package:digisong_etr/admin_Screens/admin_account_screen.dart';
import 'package:digisong_etr/admin_Screens/admin_components/playerListTile.dart';
import 'package:digisong_etr/admin_Screens/admin_components/songlisttile.dart';
import 'package:digisong_etr/admin_Screens/admin_components/admin_footer.dart';
import 'package:digisong_etr/admin_Screens/register_screen.dart';
import 'package:digisong_etr/admin_Screens/songs_management_screen.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PLayerManageMentScreen extends StatefulWidget {
  const PLayerManageMentScreen({super.key});

  @override
  State<PLayerManageMentScreen> createState() => _PLayerManageMentScreenState();
}

class _PLayerManageMentScreenState extends State<PLayerManageMentScreen> {
  var playertitleController = TextEditingController();

   Future<void> addPLayer() async {
    String capitalized = (playertitleController.text).substring(0, 1).toUpperCase() +
        (playertitleController.text).substring(1);
    final CollectionReference songsCollection =
        FirebaseFirestore.instance.collection('players');
    final DocumentReference counterRef =
        FirebaseFirestore.instance.collection('counters').doc('playerCounter');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the current counter value and increment it
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);
      int currentCount = counterSnapshot.exists
          ? (counterSnapshot.data() as Map<String, dynamic>)['count']
          : 0;
      int newCount = currentCount + 1;


      // Create a new song document with the generated ID
      final DocumentReference newSongRef = songsCollection.doc();
      await transaction.set(newSongRef, {
        'playerID': newCount,
        'playertitle': capitalized,

      });

      // Update the counter value in the "counters" collection
      transaction.update(counterRef, {'count': newCount});
      EasyLoading.showSuccess('Player ${capitalized} has been succesfully added');
      Navigator.pop(context);
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: const Text('Player ManageMent'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Player'),
                      content: TextField(
                        decoration: InputDecoration(hintText: 'Enter Player'),
                        style: inputTextSize,
                        minLines: 3,
                        maxLines: 5,
                        controller: playertitleController,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              playertitleController.clear();
                            });
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            addPLayer();
                            Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.add_circle)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('players')
                        .orderBy('playerID')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      var documents = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            return PLayerListTile(
                              player: documents[index],
                            );
                          });
                    })),
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            width: double.infinity,
            color: backColor,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminRegisterScreen()));
                  },
                  child: const Text(
                    'Add Admin',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SongManageMentScreen())));
                  },
                  child: Text('Songs'),
                  style: ElevatedButton.styleFrom(backgroundColor: red),
                ),
                Container(
                  width: 25,
                  child: DropdownButton(
                    isExpanded: true,
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Icon(Icons.logout_outlined, color: red),
                        value: 'logout',
                      ),
                      DropdownMenuItem(
                        child: FaIcon(FontAwesomeIcons.circleUser, color: red),
                        value: 'account',
                      ),
                    ],
                    onChanged: (val) {
                      if (val == 'logout') {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      } else {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AdminAccountScreen(
                                    FirebaseAuth.instance.currentUser!.uid)));
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
