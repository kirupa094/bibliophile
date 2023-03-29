import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/model/shelf_model.dart';
import 'package:bibliophile/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookCard extends StatefulWidget {
  final String title;
  final List<dynamic> author;
  final String imgUrl;
  final String year;
  final String id;
  const BookCard(
      {Key? key,
      required this.title,
      required this.author,
      required this.imgUrl,
      required this.year,
      required this.id})
      : super(key: key);

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
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
                  'By: ${widget.author.join(',')}',
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
                  iconSize: 24,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      if (dropdownValue == 'Read') {
                        bloc!.updateShelf(widget.title, widget.author,
                            widget.imgUrl, widget.year, widget.id, 'read');
                      } else if (dropdownValue == 'To be read') {
                        bloc!.updateShelf(widget.title, widget.author,
                            widget.imgUrl, widget.year, widget.id, 'toBeRead');
                      } else {
                        bloc!.updateShelf(
                            widget.title,
                            widget.author,
                            widget.imgUrl,
                            widget.year,
                            widget.id,
                            'currentlyReading');
                      }
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
            StreamBuilder<Map<String, dynamic>>(
              stream: bloc!.updateShelfResult,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  Future.delayed(
                    const Duration(microseconds: 500),
                    () async {
                      bloc.fetchShelf();
                      bloc.clearUpdateShelfOutput();
                    },
                  );

                  return const SizedBox.shrink();
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
