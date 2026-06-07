class BookmarkModel {
  final int? id;
  final int pdfId;
  final int pageNumber;
  final String title;
  final String dateAdded;

  BookmarkModel({
    this.id,
    required this.pdfId,
    required this.pageNumber,
    required this.title,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pdfId': pdfId,
      'pageNumber': pageNumber,
      'title': title,
      'dateAdded': dateAdded,
    };
  }

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'],
      pdfId: map['pdfId'],
      pageNumber: map['pageNumber'],
      title: map['title'],
      dateAdded: map['dateAdded'],
    );
  }
}
