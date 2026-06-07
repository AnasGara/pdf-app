import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/pdf_document.dart';
import '../models/bookmark.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pdf_reader.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pdfs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        path TEXT UNIQUE,
        size TEXT,
        pageCount INTEGER,
        dateAdded TEXT,
        lastOpened TEXT,
        readingProgress REAL,
        lastPage INTEGER,
        isFavorite INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pdfId INTEGER,
        pageNumber INTEGER,
        title TEXT,
        dateAdded TEXT,
        FOREIGN KEY (pdfId) REFERENCES pdfs (id) ON DELETE CASCADE
      )
    ''');
  }

  // PDF CRUD operations
  Future<int> insertPdf(PdfDocumentModel pdf) async {
    Database db = await database;
    return await db.insert('pdfs', pdf.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PdfDocumentModel>> getAllPdfs() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pdfs', orderBy: 'lastOpened DESC');
    return List.generate(maps.length, (i) => PdfDocumentModel.fromMap(maps[i]));
  }

  Future<List<PdfDocumentModel>> getFavoritePdfs() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pdfs', where: 'isFavorite = ?', whereArgs: [1], orderBy: 'lastOpened DESC');
    return List.generate(maps.length, (i) => PdfDocumentModel.fromMap(maps[i]));
  }

  Future<List<PdfDocumentModel>> getRecentPdfs() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pdfs', orderBy: 'lastOpened DESC', limit: 20);
    return List.generate(maps.length, (i) => PdfDocumentModel.fromMap(maps[i]));
  }

  Future<int> updatePdf(PdfDocumentModel pdf) async {
    Database db = await database;
    return await db.update('pdfs', pdf.toMap(), where: 'id = ?', whereArgs: [pdf.id]);
  }

  Future<int> deletePdf(int id) async {
    Database db = await database;
    return await db.delete('pdfs', where: 'id = ?', whereArgs: [id]);
  }

  // Bookmark operations
  Future<int> insertBookmark(BookmarkModel bookmark) async {
    Database db = await database;
    return await db.insert('bookmarks', bookmark.toMap());
  }

  Future<List<BookmarkModel>> getBookmarksForPdf(int pdfId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks', where: 'pdfId = ?', whereArgs: [pdfId]);
    return List.generate(maps.length, (i) => BookmarkModel.fromMap(maps[i]));
  }

  Future<int> deleteBookmark(int id) async {
    Database db = await database;
    return await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearHistory() async {
    Database db = await database;
    await db.delete('pdfs');
  }

  Future<void> clearBookmarks() async {
    Database db = await database;
    await db.delete('bookmarks');
  }
}
