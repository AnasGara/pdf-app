import '../database/database_helper.dart';
import '../models/pdf_document.dart';
import '../models/bookmark.dart';

class PdfRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> addPdf(PdfDocumentModel pdf) async {
    return await _dbHelper.insertPdf(pdf);
  }

  Future<List<PdfDocumentModel>> getAllPdfs() async {
    return await _dbHelper.getAllPdfs();
  }

  Future<List<PdfDocumentModel>> getFavoritePdfs() async {
    return await _dbHelper.getFavoritePdfs();
  }

  Future<List<PdfDocumentModel>> getRecentPdfs() async {
    return await _dbHelper.getRecentPdfs();
  }

  Future<void> updatePdf(PdfDocumentModel pdf) async {
    await _dbHelper.updatePdf(pdf);
  }

  Future<void> deletePdf(int id) async {
    await _dbHelper.deletePdf(id);
  }

  Future<void> toggleFavorite(PdfDocumentModel pdf) async {
    final updatedPdf = pdf.copyWith(isFavorite: !pdf.isFavorite);
    await _dbHelper.updatePdf(updatedPdf);
  }

  Future<void> addBookmark(BookmarkModel bookmark) async {
    await _dbHelper.insertBookmark(bookmark);
  }

  Future<List<BookmarkModel>> getBookmarks(int pdfId) async {
    return await _dbHelper.getBookmarksForPdf(pdfId);
  }

  Future<void> deleteBookmark(int id) async {
    await _dbHelper.deleteBookmark(id);
  }

  Future<void> clearHistory() async {
    await _dbHelper.clearHistory();
  }

  Future<void> clearBookmarks() async {
    await _dbHelper.clearBookmarks();
  }
}
