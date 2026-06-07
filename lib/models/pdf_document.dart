class PdfDocumentModel {
  final int? id;
  final String name;
  final String path;
  final String size;
  final int pageCount;
  final String dateAdded;
  final String lastOpened;
  final double readingProgress;
  final int lastPage;
  final bool isFavorite;

  PdfDocumentModel({
    this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.pageCount,
    required this.dateAdded,
    required this.lastOpened,
    this.readingProgress = 0.0,
    this.lastPage = 0,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'size': size,
      'pageCount': pageCount,
      'dateAdded': dateAdded,
      'lastOpened': lastOpened,
      'readingProgress': readingProgress,
      'lastPage': lastPage,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory PdfDocumentModel.fromMap(Map<String, dynamic> map) {
    return PdfDocumentModel(
      id: map['id'],
      name: map['name'],
      path: map['path'],
      size: map['size'],
      pageCount: map['pageCount'],
      dateAdded: map['dateAdded'],
      lastOpened: map['lastOpened'],
      readingProgress: map['readingProgress'],
      lastPage: map['lastPage'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  PdfDocumentModel copyWith({
    int? id,
    String? name,
    String? path,
    String? size,
    int? pageCount,
    String? dateAdded,
    String? lastOpened,
    double? readingProgress,
    int? lastPage,
    bool? isFavorite,
  }) {
    return PdfDocumentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      pageCount: pageCount ?? this.pageCount,
      dateAdded: dateAdded ?? this.dateAdded,
      lastOpened: lastOpened ?? this.lastOpened,
      readingProgress: readingProgress ?? this.readingProgress,
      lastPage: lastPage ?? this.lastPage,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
