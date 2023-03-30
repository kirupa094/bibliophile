class CommentModel {
  final String id;
  final String comment;
  final String username;
  final String photoURL;

  CommentModel.fromParsedJason(Map<String, dynamic> result)
      : id = result['_id'] ?? '',
        comment = result['comment'] ?? '',
        username = result['username'],
        photoURL= result['photoURL'];
}
