class BookModel {
  final String title;
  final String authors;
  final String publishedDate;

  BookModel.fromParsedJason(Map<String, dynamic> result)
      : title = result['volumeInfo']['title'] ?? '',
        authors = result['volumeInfo']['authors'] ?? '',
        publishedDate = result['volumeInfo']['publishedDate'] ?? '';
}
