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

  searchBook(String mobileNumber, String password, String language,
      Function(BookModel) add, Function(Object) addError) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final response = await _client.post(
        Uri.parse('$_root/api/auth/v1/$language/login'),
        headers: headers,
        body: jsonEncode(<String, String>{
          'mobile_number': mobileNumber,
          'password': password,
        }),
      );

      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        var book = (result);
        add(BookModel.fromParsedJason(book));
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
