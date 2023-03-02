import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/model/shelf_model.dart';
import 'package:bibliophile/model/signup_model.dart';
import 'package:bibliophile/resources/bibliophile_api_provider.dart';

class Repository {
  final BibliophileApiProvider _bibliophileApiProvider;
  Repository() : _bibliophileApiProvider = BibliophileApiProvider();

  void searchBook(
      String title, Function(List<BookModel>) add, Function(Object) addError) {
    _bibliophileApiProvider.searchBook(title, add, addError);
  }

  void signUp(String email, String name, String photoURL, String uid,
      Function(SignUpModel) add, Function(Object) addError) {
    _bibliophileApiProvider.signUp(email, name, photoURL, uid, add, addError);
  }

  void getShelf(
      String token, Function(ShelfBooksModel) add, Function(Object) addError) {
    _bibliophileApiProvider.getShelf(token, add, addError);
  }
}
