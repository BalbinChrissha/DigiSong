import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/admin_Screens/add_new_song.dart';
import 'package:digisong_etr/admin_Screens/admin_components/songlisttile.dart';
import 'package:digisong_etr/admin_Screens/admin_components/admin_footer.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:flutter/material.dart';

class SongManageMentScreen extends StatefulWidget {
  const SongManageMentScreen({super.key});

  @override
  State<SongManageMentScreen> createState() => _SongManageMentScreenState();
}

class _SongManageMentScreenState extends State<SongManageMentScreen> {
  String keyword = '';

  // var songstream = FirebaseFirestore.instance
  //     .collection('songs')
  //     .orderBy('title', descending: false)
  //     .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: const Text('Song ManageMent'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewSongScreen(),
                      //builder: (context) =>  MyDropdownButton(),
                    ));
              },
              icon: const Icon(Icons.add_circle)),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(13),
            child: TextField(
                // controller: controller,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black))),
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                  keyword = value;
                }),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('songs')
                        .orderBy('title')
                        .startAt([keyword]).endAt(
                            [keyword + '\uf8ff']).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      var documents = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            return SongListTile(
                              song: documents[index],
                            );
                          });
                    })),
          ),
          AdminFooterPlayer()
        ],
      ),
    );
  }
}
