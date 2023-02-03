import 'package:bibliophile/customFunction/custom_function.dart';
import 'package:bibliophile/widgets/bottom_navigation_bar_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Home/intro_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _navigateHome(String? userId) {
    if (userId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Welcome to',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Bibliophile',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: TextButton.icon(
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      padding: const EdgeInsets.all(15.0),
                      primary: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 101, 88, 245),
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final GoogleSignInAccount? googleUser =
                            await _googleSignIn.signIn();
                        final GoogleSignInAuthentication googleAuth =
                            await googleUser!.authentication;

                        final AuthCredential credential =
                            GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );

                        final UserCredential userCredential =
                            await _auth.signInWithCredential(credential);
                        if (userCredential.user != null) {
                          _navigateHome(userCredential.user!.uid);
                        }
                      } catch (e) {
                        CustomFunction.loginErrorDialog(context, e.toString());
                      }
                    },
                    icon: FaIcon(
                        color: Colors.white, FontAwesomeIcons.google, size: 30),
                    label: const Text(
                      'Login with Google',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
