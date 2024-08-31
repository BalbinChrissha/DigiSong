import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/screens/choose_player.dart';
import 'package:digisong_etr/screens/home_screen.dart';
import 'package:digisong_etr/screens/user_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterPlayer extends StatelessWidget {
  const FooterPlayer({
    super.key,
    required this.player,
  });

  final  player;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      width: double.infinity,
      color: backColor,
      child: Row(
        children: [
          Text(
            player['playertitle'],
            style: TextStyle(color: Colors.white),
          ),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ChoosePlayer())));
            },
            child: Text('Change'),
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
                }else{
                   Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ClientAccountScreen(FirebaseAuth
                                        .instance
                                        .currentUser!
                                        .uid)));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
