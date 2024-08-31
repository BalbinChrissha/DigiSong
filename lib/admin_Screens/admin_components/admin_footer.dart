import 'package:digisong_etr/admin_Screens/admin_account_screen.dart';
import 'package:digisong_etr/admin_Screens/manage_players.dart';
import 'package:digisong_etr/admin_Screens/register_screen.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminFooterPlayer extends StatelessWidget {
  const AdminFooterPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      width: double.infinity,
      color: backColor,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminRegisterScreen()));
            },
            child: const Text(
              'Add Admin',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => PLayerManageMentScreen())));
            },
            child: Text('Players'),
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
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
    );
  }
}
