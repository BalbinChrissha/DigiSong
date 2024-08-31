import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/screens/song_screen.dart';
import 'package:flutter/material.dart';

class ChoosePlayer extends StatelessWidget {
  const ChoosePlayer({super.key});

  @override
  Widget build(BuildContext context) {


    var firestore_stream =
        FirebaseFirestore.instance.collection('players').snapshots();
    return Scaffold(
      // backgroundColor: backColor,
      body: SafeArea(
          child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
              color: backColor, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: blackC,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                width: double.infinity,
                child: Column(
                  children: [
                    const Padding(
                      padding: const EdgeInsets.all(15),
                      child: const Text(
                        'CHOOSE YOUR PLAYER',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: firestore_stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      var documents = snapshot.data!.docs;
                      return ListView.builder(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          itemCount: documents.length,
                          itemBuilder: ((context, index) {
                            return (Padding(
                              padding: const EdgeInsets.all(12),
                              child: GestureDetector(
                                onTap: (() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SongScreen(
                                              player: documents[index])));
                                }),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            hexC.withOpacity(0.80),
                                            hexC
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                      documents[index]['playertitle'],
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ));
                          }));
                    }),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
