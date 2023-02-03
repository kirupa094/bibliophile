import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imgUrl;
  final String year;
  const BookCard(
      {Key? key,
      required this.title,
      required this.author,
      required this.imgUrl,
      required this.year})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/2,
      height: 250,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
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
                width: MediaQuery.of(context).size.width / 2,
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(imgUrl), fit: BoxFit.cover)),
              ),
            ),
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'title:$title',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  maxLines: 2,
                  'By: $author',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'Year: ${year.split('-')[0]}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
