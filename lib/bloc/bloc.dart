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
        _initDataConfig = BehaviorSubject<InitData>();

  getInitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _initDataConfig.sink.add(InitData(
      token: prefs.getString('token') ?? "",
    ));

    String? token = prefs.getString('token');

    _token = token ?? '';
  }
}