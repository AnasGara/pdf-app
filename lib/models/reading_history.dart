class ReadingHistoryModel {
  final int id;
  final int pdfId;
  final String lastOpened;
  final double progress;
  final int lastPage;

  ReadingHistoryModel({
    required this.id,
    required this.pdfId,
    required this.lastOpened,
    required this.progress,
    required this.lastPage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pdfId': pdfId,
      'lastOpened': lastOpened,
      'progress': progress,
      'lastPage': lastPage,
    };
  }

  factory ReadingHistoryModel.fromMap(Map<String, dynamic> map) {
    return ReadingHistoryModel(
      id: map['id'],
      pdfId: map['pdfId'],
      lastOpened: map['lastOpened'],
      progress: map['progress'],
      lastPage: map['lastPage'],
    );
  }
}
