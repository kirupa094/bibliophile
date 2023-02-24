import 'dart:convert';
import 'dart:io';

import 'package:bibliophile/model/book_model.dart';
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
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final response = await _client.get(
        Uri.parse('$_root/book/search?query=$title'),
        headers: headers,
      );

      final result = json.decode(response.body);
      if (response.statusCode == 201) {
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
}
