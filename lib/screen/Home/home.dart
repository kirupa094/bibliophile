import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ignore: prefer_const_constructors
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/splash.png',
                    ),
                    Text('Bibliophile')
                  ],
                ),
              ),
              Container(
                // ignore: prefer_const_constructors
                height: 80,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/splash.png'),
                    alignment: Alignment.topLeft,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Bibliophile',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1),
                ),
              ),
            ],
          ),
          // title: const Text(
          //   'Bibliophile',
          //   style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 30,
          //       fontWeight: FontWeight.w700,
          //       letterSpacing: 1),
          // ),
          //  Container(
          //   // ignore: prefer_const_constructors
          //   height: 80,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/splash.png'),
          //     alignment: Alignment.topLeft,
          //     fit: BoxFit.fitHeight,
          //   ),
          // ),
          // ),
          backgroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('ge'),
        ),
      ),
    );
  }
}
