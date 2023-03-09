import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/customFunction/custom_function.dart';
import 'package:bibliophile/model/signup_model.dart';
import 'package:bibliophile/util/constant.dart';
import 'package:bibliophile/widgets/bottom_navigation_bar_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/intro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _signIn(String token, bool isNewUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    _navigateHome(token, isNewUser);
  }

  _navigateHome(String? token, bool isNewUser) {
    if (!isNewUser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const BottomNavigationBarMenu()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return WillPopScope(
      onWillPop: () async => true,
      child: SafeArea(
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
                        backgroundColor:
                            const Color.fromARGB(255, 101, 88, 245),
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final UserCredential userCredential =
                              await bloc!.signInWithGoogle(context);
                          final token = await userCredential.user!.getIdToken();
                          final isNewUser =
                              userCredential.additionalUserInfo!.isNewUser;
                          if (userCredential.user != null) {
                            bloc.setToken(token);
                            bloc.setUserImage(
                                userCredential.user?.photoURL ?? '');
                            bloc.setUserName(
                                userCredential.user?.displayName ?? '');
                            bloc.fetchRegister(
                                userCredential.user?.email ?? '',
                                userCredential.user?.displayName ?? '',
                                userCredential.user?.photoURL ?? '',
                                userCredential.user!.uid);
                            Future.delayed(
                              const Duration(microseconds: 500),
                              () async {
                                _showProgressBar(
                                    context, bloc, token, isNewUser);
                              },
                            );
                          }
                        } catch (e) {
                          CustomFunction.loginErrorDialog(
                              context, e.toString());
                        }
                      },
                      icon: FaIcon(
                          color: Colors.white,
                          FontAwesomeIcons.google,
                          size: 30),
                      label: const Text(
                        'Login with Google',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showProgressBar(
      BuildContext rootContext, Bloc bloc, String token, bool isNewUser) async {
    return showDialog<void>(
      context: rootContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StreamBuilder<SignUpModel>(
          stream: bloc.register,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.id != '') {
                Future.delayed(
                  const Duration(microseconds: 500),
                  () async {
                    _signIn(token, isNewUser);
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(textPrimary)),
              );
            } else if (snapshot.hasError && snapshot.error != null) {
              return AlertDialog(
                  titlePadding:
                      const EdgeInsets.only(left: 20, right: 10, top: 20),
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.error_outline,
                              color: textWarning,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'ALERT!',
                              style: TextStyle(
                                  color: textWarning,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            )
                          ],
                        )
                      ]),
                  content: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'You Already registered! click to post :)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textPrimary, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: bgInfo,
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10)),
                      child: const Text('OK',
                          style: TextStyle(color: textSecondary, fontSize: 14)),
                      onPressed: () {
                        _signIn(token, isNewUser);
                      },
                    )
                  ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(textPrimary)),
              );
            }
          },
        );
      },
    );
  }
}
