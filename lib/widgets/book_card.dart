// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 200,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
          ]),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: 150,
                height: 130,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9R_McJgTQzUpfPJVEXadatDd40pM9fkzyKw&usqp=CAU'),
                        fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(
              width: 150,
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'title:Harry Potter',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(
              width: 150,
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  maxLines: 2,
                  'By:J.K. Rowling',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(
              width: 150,
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'Year: 2002',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
