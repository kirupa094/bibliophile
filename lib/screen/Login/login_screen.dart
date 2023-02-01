import 'package:bibliophile/widgets/bottom_navigation_bar_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/splash.png'),
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
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BottomNavigationBarMenu()))
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
