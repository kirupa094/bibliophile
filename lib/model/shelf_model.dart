class ShelfBooksModel {
  final String id;
  final String uid;
  final List readBooks;
  final List currentlyReadingBooks;
  final List toBeReadBooks;
  final String addedDate;

  ShelfBooksModel.fromParsedJason(Map<String, dynamic> result)
      : id = result['_id'] ?? '',
        uid = result['uid'] ?? '',
        readBooks = result['readBooks'] ?? [],
        currentlyReadingBooks = result['currentlyReadingBooks'] ?? [],
        toBeReadBooks = result['toBeReadBooks'] ?? [],
        addedDate = result['addedDate'] ?? '';
}
