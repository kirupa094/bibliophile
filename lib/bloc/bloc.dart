import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/resources/repository.dart';
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
