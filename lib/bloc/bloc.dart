import 'package:bibliophile/customFunction/custom_function.dart';
import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/model/shelf_model.dart';
import 'package:bibliophile/model/signup_model.dart';
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
  final BehaviorSubject<SignUpModel> _registerUser;
  final BehaviorSubject<ShelfBooksModel> _shelfResult;
  final BehaviorSubject<ShelfBooksModel> _addShelfResult;

  String _token = "";
  String _userImage = "";
  String _userName = "";

  static final Bloc _bloc = Bloc._internal();

  factory Bloc() {
    return _bloc;
  }

  String getSavedUserToken() {
    return _token;
  }

  String getUserName() {
    return _userName;
  }

  String getUserImage() {
    return _userImage;
  }

  setToken(String token) {
    _token = token;
  }

  setUserName(String userName) {
    _userName = userName;
  }

  setUserImage(String userImage) {
    _userImage = userImage;
  }

  Bloc._internal()
      : _repository = Repository(),
        _initDataConfig = BehaviorSubject<InitData>(),
        _searchController = BehaviorSubject<String>(),
        _bookResult = BehaviorSubject<List<BookModel>>(),
        _registerUser = BehaviorSubject<SignUpModel>(),
        _shelfResult = BehaviorSubject<ShelfBooksModel>(),
        _addShelfResult = BehaviorSubject<ShelfBooksModel>();

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
      _userImage = userCredential.user?.photoURL ?? '';
      _userName = userCredential.user?.displayName ?? '';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);
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

  //REGISTER USER
  Stream<SignUpModel> get register => _registerUser.stream;
  Function(String, String, String, String) get fetchRegister => _fetchRegister;

  _addToRegisterStream(SignUpModel signUpModel) {
    _registerUser.sink.add(signUpModel);
  }

  _fetchRegister(String email, String name, String photoURL, String uid) {
    _repository.signUp(email, name, photoURL, uid, _addToRegisterStream,
        _registerUser.sink.addError);
  }

  //SHELF
  //GET SHELF BOOKS
  Stream<ShelfBooksModel> get getShelfResult => _shelfResult.stream;
  Function() get fetchShelf => _fetchShelf;

  _addToShelfStream(ShelfBooksModel shelfBooksModel) {
    _shelfResult.sink.add(shelfBooksModel);
  }

  _fetchShelf() {
    if (_token != '') {
      _repository.getShelf(
          _token, _addToShelfStream, _shelfResult.sink.addError);
    }
  }

  //ADD BOOKS TO SHELF
  Stream<ShelfBooksModel> get updateShelfResult => _addShelfResult.stream;
  Function(String, String, String, String, String, String) get updateShelf =>
      _updateShelf;

  _updateShelfStream(ShelfBooksModel shelfBooksModel) {
    _addShelfResult.sink.add(shelfBooksModel);
  }

  _updateShelf(
    String title,
    String author,
    String cover,
    String year,
    String id,
    String category,
  ) {
    if (_token != '') {
      _repository.updateShelfRequest(_token, title, author, cover, year, id,
          category, _updateShelfStream, _addShelfResult.sink.addError);
    }
  }
}
