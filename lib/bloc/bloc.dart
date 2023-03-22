import 'package:bibliophile/customFunction/custom_function.dart';
import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/model/create_post_model.dart';
import 'package:bibliophile/model/post_model.dart';
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
  final BehaviorSubject<Map<String, dynamic>> _createPostResult;
  final BehaviorSubject<List<PostModel>> _getAllPostResult;
  final BehaviorSubject<List<PostModel>> _getAllPostByCreatorResult;
  final BehaviorSubject<Map<String, dynamic>> _savePostResult;

  String _token = "";
  String _userImage = "";
  String _userName = "";
  String _userId = "";

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

  String getUserId() {
    return _userId;
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

  setUserId(String userId) {
    _userId = userId;
  }

  Bloc._internal()
      : _repository = Repository(),
        _initDataConfig = BehaviorSubject<InitData>(),
        _searchController = BehaviorSubject<String>(),
        _bookResult = BehaviorSubject<List<BookModel>>(),
        _registerUser = BehaviorSubject<SignUpModel>(),
        _shelfResult = BehaviorSubject<ShelfBooksModel>(),
        _addShelfResult = BehaviorSubject<ShelfBooksModel>(),
        _createPostResult = BehaviorSubject<Map<String, dynamic>>(),
        _getAllPostResult = BehaviorSubject<List<PostModel>>(),
        _getAllPostByCreatorResult = BehaviorSubject<List<PostModel>>(),
        _savePostResult = BehaviorSubject<Map<String, dynamic>>();

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
      _userId = userCredential.user!.uid;
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
  Function(String, List<dynamic>, String, String, String, String)
      get updateShelf => _updateShelf;

  _updateShelfStream(ShelfBooksModel shelfBooksModel) {
    _addShelfResult.sink.add(shelfBooksModel);
  }

  _updateShelf(
    String title,
    List<dynamic> author,
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

  //POST

  //Create Post
  Stream<Map<String, dynamic>> get createPostOutput => _createPostResult.stream;
  Function(CreatePostModel) get postCreatePostOutput => _postCreatePostOutput;

  _addToCreatePostOutputStream(Map<String, dynamic> lst) {
    _createPostResult.sink.add(lst);
  }

  _postCreatePostOutput(CreatePostModel createPostModel) {
    if (_token != '') {
      _repository.createPost(_token, createPostModel,
          _addToCreatePostOutputStream, _createPostResult.sink.addError);
    }
  }

  void clearPostCreatePostOutput() {
    _createPostResult.sink.add({});
  }

  //Get All Posts
  Stream<List<PostModel>> get getAllPosts => _getAllPostResult.stream;
  Function() get fetchAllPosts => _fetchAllPosts;

  _addToGetAllPostStream(List<PostModel> lst) {
    _getAllPostResult.sink.add(lst);
  }

  _fetchAllPosts() {
    if (_token != '') {
      _repository.getAllPosts(
          _token, _addToGetAllPostStream, _getAllPostResult.sink.addError);
    }
  }

  //Get All Posts By Creator
  Stream<List<PostModel>> get getAllPostsByCreator =>
      _getAllPostByCreatorResult.stream;
  Function(String) get fetchAllPostsByCreator => _fetchAllPostsByCreator;

  _addToGetAllPostByCreatorStream(List<PostModel> lst) {
    _getAllPostByCreatorResult.sink.add(lst);
  }

  _fetchAllPostsByCreator(String creatorId) {
    if (_token != '') {
      _repository.getAllPostsByCreator(_token, creatorId,
          _addToGetAllPostByCreatorStream, _getAllPostResult.sink.addError);
    }
  }

  //Save Post
  Stream<Map<String, dynamic>> get savePost => _savePostResult.stream;
  Function(String) get savePostOutput => _savePostOutput;

  void clearSavePostOutput() {
    _savePostResult.sink.add({});
  }

  _addToSavePostOutputStream(Map<String, dynamic> lst) {
    _savePostResult.sink.add(lst);
  }

  _savePostOutput(String postId) {
    if (_token != '') {
      _repository.savePost(_token, postId, _addToSavePostOutputStream,
          _savePostResult.sink.addError);
    }
  }
}
