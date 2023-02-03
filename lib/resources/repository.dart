import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/resources/bibliophile_api_provider.dart';

class Repository {
  final BibliophileApiProvider _bibliophileApiProvider;
  Repository() : _bibliophileApiProvider = BibliophileApiProvider();

  void searchBook(String title,
      Function(List<BookModel>) add, Function(Object) addError) {
    _bibliophileApiProvider.searchBook(title, add, addError);
  }
}
