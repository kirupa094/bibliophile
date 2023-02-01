import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ignore: prefer_const_constructors
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.accessibility),
          title: const Text(
            'Bibliophile',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
          ),
          flexibleSpace: Container(
            // ignore: prefer_const_constructors
            height: 80,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('ge'),
        ),
      ),
    );
  }
}
