class BookModel {
  final String id;
  final String title;
  final List authors;
  final String publishedDate;
  final String thumbnail;

  BookModel.fromParsedJason(Map<String, dynamic> result)
      : id = result['id'] ?? '',
        title = result['volumeInfo']['title'] ?? '',
        authors = result['volumeInfo']['authors'] ?? [],
        publishedDate = result['volumeInfo']['publishedDate'] ?? '',
        thumbnail=result['volumeInfo']?['imageLinks']?['thumbnail'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8KtZQxVnXOlVQ2iRXWxTEG8_rg4-s-zB5XQ&usqp=CAU';
}
