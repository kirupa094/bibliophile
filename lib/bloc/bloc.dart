import 'package:bibliophile/customFunction/custom_function.dart';
import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/resources/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitData {
  final String token;
  InitData({
    this.token = "",
  });
}

class Bloc {
  final Repository _repository;
  final BehaviorSubject<InitData> _initDataConfig;
  final BehaviorSubject<String> _searchController;
  final BehaviorSubject<List<BookModel>> _bookResult;

  String _token = "";

  static final Bloc _bloc = Bloc._internal();

  factory Bloc() {
    return _bloc;
  }

  String getSavedUserToken() {
    return _token;
  }

  setToken(String token) {
    _token = token;
  }

  Bloc._internal()
      : _repository = Repository(),
        _initDataConfig = BehaviorSubject<InitData>(),
        _searchController = BehaviorSubject<String>(),
        _bookResult = BehaviorSubject<List<BookModel>>();

  //AUTH SERVICES
  signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return getCredential(credential, context);
    } catch (e) {
      CustomFunction.loginErrorDialog(context, e.toString());
    }
  }

  getCredential(AuthCredential credential, BuildContext context) async {
    try {
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      CustomFunction.loginErrorDialog(context, e.toString());
    }
  }

  refreshToken(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signInSilently();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await getCredential(credential, context);
      final token = await userCredential.user!.getIdToken();
      _token = token;
    } catch (e) {
      CustomFunction.loginErrorDialog(context, e.toString());
    }
  }

  //INIT DATA
  getInitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _initDataConfig.sink.add(InitData(
      token: prefs.getString('token') ?? "",
    ));

    String? token = prefs.getString('token');
    _token = token ?? '';
  }

  //INIT DATA
  Stream<InitData> get initDataConfig => _initDataConfig.stream;
  Function(InitData) get changeInitDataConfig => _initDataConfig.sink.add;

  //SEARCH CONTROLLER

  Function(String) get searchBook => _searchController.sink.add;
  Stream<String> get booksList => _searchController.stream;

  Stream<List<BookModel>> get getBookList => _bookResult.stream;
  Function(String) get fetchBooks => _fetchBooks;

  _addToBookListStream(List<BookModel> bookModel) {
    _bookResult.sink.add(bookModel);
  }

  _fetchBooks(String title) {
    _repository.searchBook(
        title, _addToBookListStream, _bookResult.sink.addError);
  }
}
