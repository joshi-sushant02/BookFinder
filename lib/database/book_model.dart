class BookModel {
  // int bookid;
  String author;
  String title;
  String cover;
  String note;
  BookModel({
    // required this.bookid,
    required this.cover,
    required this.author,
    required this.title,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return ({
      // 'bookid': bookid,
      'title': title,
      'author': author,
      'cover': cover,
      'note': note
    });
  }
}
