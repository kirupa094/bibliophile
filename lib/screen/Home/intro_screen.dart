import 'dart:convert';
import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/customFunction/custom_function.dart';
import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/screen/Home/home.dart';
import 'package:bibliophile/widgets/book_card.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TextEditingController _textController = TextEditingController();
  bool click = false;
  String errorMsg = '';
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
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
            margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello Nithur!',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Let’s start by adding some books...!',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder(
                  stream: bloc!.booksList,
                  builder: (context, snapshot) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 118, 118, 118),
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                          hintText: "Search books by title,author",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (snapshot.hasData) {
                                setState(() {
                                  click = true;
                                });
                                bloc.fetchBooks(snapshot.data.toString());
                              }
                            },
                          ),
                            errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: textWarning, width: 2),
                        ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 238, 238, 238),
                                width: 2),
                          ),
                           focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 238, 238, 238),
                              width: 2),
                        ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                          if (value.length > 3) {
                            setState(() {
                              errorMsg = '';
                            });
                            bloc.searchBook(value);
                          } else {
                            setState(() {
                              click = false;
                              errorMsg =
                                  'Search Text Length Must Be Greater Than 3';
                            });
                          }
                        } else {
                          setState(() {
                            click = false;
                            errorMsg = '';
                          });
                        }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                 click
                    ? Flexible(
                        child: StreamBuilder<List<BookModel>>(
                          stream: bloc.getBookList,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return _buildList(snapshot.data, context);
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          persistentFooterButtons: [
            Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 101, 88, 245),
              ),
              child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  child: const Center(
                    child: Text('Later',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  )),
            ),
          ]),
    );
  }

  _buildList(List<BookModel>? lst, BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: lst!.length,
        itemBuilder: (BuildContext ctx, index) {
          return BookCard(
            imgUrl: lst[index].thumbnail,
            title: lst[index].title,
            author: jsonEncode(lst[index].authors),
            year: lst[index].publishedDate,
          );
        });
  }
}
