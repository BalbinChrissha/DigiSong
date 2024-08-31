import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digisong_etr/admin_Screens/songs_management_screen.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/firebase_options.dart';
import 'package:digisong_etr/screens/choose_player.dart';
import 'package:digisong_etr/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DigiSong());
}

class DigiSong extends StatelessWidget {
  const DigiSong({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: const TextTheme(
          titleSmall: titleS, displayMedium: displayM),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[200],
          elevation: 0,
        ),
      ),
     // home: LyricsListScreen(),
      home: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //check if the snapshot has data; means use logged
          if (snapshot.hasData) {
            var uid = FirebaseAuth.instance.currentUser!.uid;
            ValueNotifier<Widget> landingScreen =
                ValueNotifier<Widget>(HomeScreen());

            var userDocRef =
                FirebaseFirestore.instance.collection('users').doc(uid);
            userDocRef.snapshots().listen((docSnapshot) {
              var userType = docSnapshot.data()?['type'];
              if (userType == 'client') {
                landingScreen.value = ChoosePlayer();
              } else {
                landingScreen.value = SongManageMentScreen();
              }
            });
            print(uid);
            return ValueListenableBuilder<Widget>(
              valueListenable: landingScreen,
              builder: (context, value, child) => value,
            );
          }
          return HomeScreen();
          // return Scaffold();
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
      builder: EasyLoading.init(),
    );
  }
}
