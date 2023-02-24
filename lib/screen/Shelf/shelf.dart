import 'package:bibliophile/widgets/book_card.dart';
import 'package:flutter/material.dart';

class Shelf extends StatelessWidget {
  const Shelf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.only(left: 2),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.fitWidth),
                  ),
                  width: 60,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Bibliophile',
                  style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: BookCard(
              author: 'kiruba',
              imgUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8KtZQxVnXOlVQ2iRXWxTEG8_rg4-s-zB5XQ&usqp=CAU',
              title: 'Love One',
              year: '2023'),
        ),
      ),
    );
  }
}