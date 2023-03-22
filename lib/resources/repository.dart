import 'package:bibliophile/model/book_model.dart';
import 'package:bibliophile/model/create_post_model.dart';
import 'package:bibliophile/model/post_model.dart';
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

  void updateShelfRequest(
      String token,
      String title,
      List<dynamic> author,
      String cover,
      String year,
      String id,
      String category,
      Function(ShelfBooksModel) add,
      Function(Object) addError) {
    _bibliophileApiProvider.updateShelfRequest(
        token, title, author, cover, year, id, category, add, addError);
  }

  void createPost(String token, CreatePostModel createPostModel,
      Function(Map<String, dynamic>) add, Function(Object) addError) {
    _bibliophileApiProvider.createPost(token, createPostModel, add, addError);
  }

  void getAllPosts(
      String token, Function(List<PostModel>) add, Function(Object) addError) {
    _bibliophileApiProvider.getAllPosts(token, add, addError);
  }

  void getAllPostsByCreator(String token, String creatorId,
      Function(List<PostModel>) add, Function(Object) addError) {
    _bibliophileApiProvider.getAllPostsByCreator(
        token, creatorId, add, addError);
  }

  void savePost(String token, String postId, Function(Map<String, dynamic>) add,
      Function(Object) addError) {
    _bibliophileApiProvider.savePost(token, postId, add, addError);
  }

  void getAllSavedPosts(
      String token, Function(List<PostModel>) add, Function(Object) addError) {
    _bibliophileApiProvider.getAllSavedPosts(token, add, addError);
  }

  void likePost(String token, String postId, String userName, String userImage,
      Function(Map<String, dynamic>) add, Function(Object) addError) {
    _bibliophileApiProvider.likePost(
        token, postId, userName, userImage, add, addError);
  }
}
