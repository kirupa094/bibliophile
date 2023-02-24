import 'package:bibliophile/util/constant.dart';
import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
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
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 250,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
          ]),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(widget.imgUrl), fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'title:${widget.title}',
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
                  'By: ${widget.author}',
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
                  'Year: ${widget.year.split('-')[0]}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              height: 35,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    filled: true,
                    fillColor: Colors.white30,
                    labelStyle: const TextStyle(color: textPrimary),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: bgPrimary),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: textWarning,
                        )),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: textWarning,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: bgPrimary),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  value: dropdownValue,
                  hint: const Text('ADD'),
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['Read', 'To be read', 'Currently reading']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}