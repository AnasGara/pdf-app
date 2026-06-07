import 'package:flutter/foundation.dart';
import '../models/pdf_document.dart';
import '../repositories/pdf_repository.dart';
import '../services/file_service.dart';

class PdfProvider with ChangeNotifier {
  final PdfRepository _repository = PdfRepository();
  final FileService _fileService = FileService();

  List<PdfDocumentModel> _recentPdfs = [];
  List<PdfDocumentModel> _favoritePdfs = [];
  List<PdfDocumentModel> _allPdfs = [];
  bool _isLoading = false;

  List<PdfDocumentModel> get recentPdfs => _recentPdfs;
  List<PdfDocumentModel> get favoritePdfs => _favoritePdfs;
  List<PdfDocumentModel> get allPdfs => _allPdfs;
  bool get isLoading => _isLoading;

  PdfProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _allPdfs = await _repository.getAllPdfs();
    _recentPdfs = await _repository.getRecentPdfs();
    _favoritePdfs = await _repository.getFavoritePdfs();

    _isLoading = false;
    notifyListeners();
  }

  Future<PdfDocumentModel?> pickAndAddPdf() async {
    final pdf = await _fileService.pickPdfFile();
    if (pdf != null) {
      await _repository.addPdf(pdf);
      await loadData();
      return _allPdfs.firstWhere((element) => element.path == pdf.path);
    }
    return null;
  }

  Future<void> toggleFavorite(PdfDocumentModel pdf) async {
    await _repository.toggleFavorite(pdf);
    await loadData();
  }

  Future<void> updateProgress(PdfDocumentModel pdf, int lastPage, double progress) async {
    final updatedPdf = pdf.copyWith(
      lastPage: lastPage,
      readingProgress: progress,
      lastOpened: DateTime.now().toIso8601String(),
    );
    await _repository.updatePdf(updatedPdf);
    await loadData();
  }

  Future<void> deletePdf(int id) async {
    await _repository.deletePdf(id);
    await loadData();
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    await loadData();
  }

  Future<void> clearBookmarks() async {
    await _repository.clearBookmarks();
    await loadData();
  }
}
