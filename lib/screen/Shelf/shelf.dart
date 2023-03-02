import 'dart:convert';

import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/model/shelf_model.dart';
import 'package:bibliophile/util/constant.dart';
import 'package:bibliophile/widgets/book_card.dart';
import 'package:flutter/material.dart';

class Shelf extends StatefulWidget {
  const Shelf({Key? key}) : super(key: key);

  @override
  State<Shelf> createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> {
  final TextEditingController _textController = TextEditingController();
  bool click = false;
  String errorMsg = '';
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    bloc?.fetchShelf();
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
          child: Column(
            children: [
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
                        errorText: errorMsg != '' ? errorMsg : null,
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
              Flexible(
                //height: MediaQuery.of(context).size.height - 250,
                child: SingleChildScrollView(
                  child: click
                      ? StreamBuilder<List<BookModel>>(
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
                        )
                      : StreamBuilder<ShelfBooksModel>(
                          stream: bloc.getShelfResult,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return _buildShelf(snapshot.data, context);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildList(List<BookModel>? lst, BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      itemCount: lst!.length,
      itemBuilder: (BuildContext ctx, index) {
        return BookCard(
          imgUrl: lst[index].thumbnail,
          title: lst[index].title,
          author: jsonEncode(lst[index].authors),
          year: lst[index].publishedDate,
        );
      },
    );
  }

  Column customShelfColumn(String title, List lst) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 300,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              width: 15,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: lst.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return BookCard(
                imgUrl: lst[index]?['cover'] ??
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8KtZQxVnXOlVQ2iRXWxTEG8_rg4-s-zB5XQ&usqp=CAU',
                title: lst[index]?['title'] ?? 'Default',
                author: jsonEncode(lst[index]?['author'] ?? ['empty']),
                year: '2023',
              );
            },
          ),
        ),
      ],
    );
  }

  _buildShelf(ShelfBooksModel? shelfBooksModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 350,
            child: customShelfColumn('Read Books', shelfBooksModel!.readBooks)),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 350,
            child: customShelfColumn(
                'Currently Reading Books', shelfBooksModel.readBooks)),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 350,
            child: customShelfColumn(
                'To Be Read Books', shelfBooksModel.readBooks)),
      ],
    );
  }
}
