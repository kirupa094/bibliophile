import 'dart:convert';
import 'dart:io';
import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/model/shelf_model.dart';
import 'package:bibliophile/model/signup_model.dart';
import 'package:http/http.dart';

class BibliophileApiProvider {
  final Client _client;
  final String _root;
  final String _networkErrorMsg = 'Please check your internet connection';

  BibliophileApiProvider()
      : _client = Client(),
        _root = 'http://localhost:3001';

  searchBook(String title, Function(List<BookModel>) add,
      Function(Object) addError) async {
    add([]);
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final response = await _client.get(
        Uri.parse('$_root/book/search?key=$title'),
        headers: headers,
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        List<BookModel> lst = [];

        var items = (result);
        if (items != null) {
          for (var item in items) {
            lst.add(BookModel.fromParsedJason(item));
          }
        }
        add(lst);
      } else {
        addError('${result['message']}');
      }
    } on SocketException {
      addError(_networkErrorMsg);
    } catch (e) {
      addError(e);
    }
  }

  signUp(String email, String name, String photoURL, String uid,
      Function(SignUpModel) add, Function(Object) addError) async {
    add(SignUpModel.fromParsedJason({}));
    try {
      final response = await _client.post(
        Uri.parse('$_root/user/signup'),
        body: jsonEncode(<String, String>{
          "email": email,
          "name": name,
          "photoURL": photoURL,
          "uid": uid
        }),
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        var user = (result);
        add(SignUpModel.fromParsedJason(user));
      } else {
        addError('${result['message']}');
      }
    } on SocketException {
      addError(_networkErrorMsg);
    } catch (e) {
      addError(e);
    }
  }

  getShelf(String token, Function(ShelfBooksModel) add,
      Function(Object) addError) async {
    //add(ShelfBooksModel.fromParsedJason({}));
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $token',
      };
      final response = await _client.get(
        Uri.parse('$_root/shelf'),
        headers: headers,
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        add(ShelfBooksModel.fromParsedJason(result));
      } else {
        addError('${result['message']}');
      }
    } on SocketException {
      addError(_networkErrorMsg);
    } catch (e) {
      addError(e);
    }
  }

  updateShelfRequest(
      String token,
      String title,
      String author,
      String cover,
      String year,
      String id,
      String category,
      Function(ShelfBooksModel) add,
      Function(Object) addError) async {
    add(ShelfBooksModel.fromParsedJason({}));
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $token',
      };
      final response = await _client.put(
        Uri.parse('$_root/shelf/:$category'),
        headers: headers,
        body: jsonEncode(
          <String, String>{
            "title": title,
            "author": author,
            "cover": cover,
            "year": year,
            "id": id
          },
        ),
      );

      final result = json.decode(response.body);
      if (response.statusCode == 201) {
        add(ShelfBooksModel.fromParsedJason(result));
      } else {
        addError('${result['message']}');
      }
    } on SocketException {
      addError(_networkErrorMsg);
    } catch (e) {
      addError(e);
    }
  }
}
