class PostModel {
  final List likes;
  final List comments;
  final List saves;
  final DateTime createdAt;
  final String id;
  final String bookId;
  final String bookTitle;
  final String bookCover;
  final String title;
  final String message;
  final String name;
  final String creatorId;

  PostModel.fromParsedJson(Map<String, dynamic> result)
      : id = result['_id'] ?? '',
        bookId = result['book_id'] ?? '',
        bookTitle = result['book_title'] ?? '',
        bookCover = result['book_cover'] ?? '',
        title = result['title'] ?? '',
        message = result['message'] ?? '',
        name = result['name'] ?? '',
        creatorId = result['creator'] ?? '',
        likes = result['likes'] ?? [],
        comments = result['comments'] ?? [],
        saves = result['saves'] ?? [],
        createdAt = DateTime.parse(result['createdAt']).toLocal();
}
