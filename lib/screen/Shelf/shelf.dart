import 'package:flutter/material.dart';

class Shelf extends StatelessWidget {
  const Shelf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'Shelf',
        style: TextStyle(color: Colors.black),
      )),
    );
  }
}
