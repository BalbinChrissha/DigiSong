import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dgsong_login.png'),
              alignment: Alignment.center,
              opacity: 0.35,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('DigiSong',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
              Text(
                'Sing, Play, Repeat: DigiSong\'s Ultimate Karaoke Companion!',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                'Please login or signup',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    shape: roundShape, backgroundColor: red),
                child: const Text('Login'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                    shape: roundShape, foregroundColor: red),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
