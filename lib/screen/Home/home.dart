import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/model/create_post_model.dart';
import 'package:bibliophile/model/shelf_model.dart';
import 'package:bibliophile/screen/Post/post.dart';
import 'package:bibliophile/util/constant.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    bloc!.fetchAllPosts();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _dialogBuilder(context),
          backgroundColor: const Color.fromARGB(255, 101, 88, 245),
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<Map<String, dynamic>>(
          stream: bloc.createPostOutput,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final msg = snapshot.data!['message'] as String;
              Future.delayed(
                const Duration(microseconds: 500),
                () async {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(msg),
                    duration: const Duration(seconds: 1),
                  ));
                  bloc.fetchAllPosts();
                  bloc.clearPostCreatePostOutput();
                },
              );
            }
            return const Post();
          },
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    final bloc = Provider.of(context);
    bloc?.fetchShelf();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    late String bookTitle;
    late String bookId;
    late String bookCover;
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("What's on your mind :)"),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<ShelfBooksModel>(
                    stream: bloc!.getShelfResult,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<Map<String, dynamic>> allBooks = [];

                        if (snapshot.data!.readBooks.isNotEmpty) {
                          allBooks.addAll(List<Map<String, dynamic>>.from(
                              snapshot.data!.readBooks));
                        }

                        if (snapshot.data!.currentlyReadingBooks.isNotEmpty) {
                          allBooks.addAll(List<Map<String, dynamic>>.from(
                              snapshot.data!.currentlyReadingBooks));
                        }

                        if (snapshot.data!.toBeReadBooks.isNotEmpty) {
                          allBooks.addAll(List<Map<String, dynamic>>.from(
                              snapshot.data!.toBeReadBooks));
                        }
                        bookTitle = allBooks.first['title'];
                        bookId = allBooks.first['id'];
                        bookCover = allBooks.first['cover'];
                        return DropdownButtonFormField(
                          value: allBooks.isNotEmpty ? allBooks.first : null,
                          items: allBooks
                              .map((book) => DropdownMenuItem(
                                  value: book, child: Text(book['title'])))
                              .toList(),
                          onChanged: (book) {
                            final selectedBook = book as Map<String, dynamic>;
                            bookTitle = selectedBook['title'];
                            bookId = selectedBook['id'] as String;
                            bookCover = selectedBook['cover'] as String;
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Book',
                            hintText: 'Select Book',
                            errorText: allBooks.isEmpty
                                ? 'Please add your book in shelf'
                                : null,
                            errorStyle:
                                const TextStyle(fontSize: 12, height: 0.7),
                            contentPadding: const EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: Colors.white30,
                            //labelText: "Select fish breed",
                            labelStyle: const TextStyle(color: textPrimary),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: bgPrimary),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  color: textWarning,
                                )),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: textWarning,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: bgPrimary),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter Title',
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
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    maxLines: 10,
                    controller: descriptionController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter Description',
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
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.headline6,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.headline6,
              ),
              child: const Text('Post'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  CreatePostModel data = CreatePostModel(
                    bookId: bookId,
                    bookTitle: bookTitle,
                    bookCover: bookCover,
                    title: titleController.text,
                    msg: descriptionController.text,
                    name: bloc.getUserName(),
                  );
                  bloc.postCreatePostOutput(data);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
