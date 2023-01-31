import 'package:bibliophile/screen/Home/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliophile App',
      theme: ThemeData(
        backgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
