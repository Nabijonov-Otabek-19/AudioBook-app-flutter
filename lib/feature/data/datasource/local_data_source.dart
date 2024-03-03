import 'dart:async';

import 'package:audiobook_app/core/utils/constants.dart';
import 'package:audiobook_app/feature/data/model/audiofile_model.dart';
import 'package:audiobook_app/feature/data/model/book_model.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

abstract class DatabaseHelper {
  Future saveBooks(List<BookModel> books);

  Future saveAudioFiles(List<AudioFileModel> audioFiles);

  Future<List<BookModel>> getBooks(int offset, int limit);

  Future<List<AudioFileModel>> fetchAudioFiles(String? bookId);
}

class DatabaseHelperImpl implements DatabaseHelper {
  static Database? _db;

  final String createAudiofilesTable = """
    CREATE TABLE ${DbTexts.audioFilesTable} (
      ${DbTexts.afNameColumn} TEXT PRIMARY KEY,
      ${DbTexts.columnTitle} TEXT,
      ${DbTexts.afUrlColumn} TEXT,
      ${DbTexts.afBookIdColumn} TEXT,
      ${DbTexts.afLengthColumn} FLOAT,
      ${DbTexts.afTrackColumn} INTEGER,
      ${DbTexts.afSizeColumn} INTEGER
    );
  """;

  final String createBooksTable = """
    CREATE TABLE ${DbTexts.bookTable} (
      ${DbTexts.columnId} TEXT PRIMARY KEY,
      ${DbTexts.columnTitle} TEXT,
      ${DbTexts.bookDescriptionColumn} TEXT,
      ${DbTexts.bookCreatorColumn} TEXT,
      ${DbTexts.bookRuntimeColumn} TEXT,
      ${DbTexts.bookDateColumn} TEXT,
      ${DbTexts.bookDownloadsColumn} INTEGER,
      ${DbTexts.bookItemSizeColumn} INTEGER,
      ${DbTexts.bookAvgRatingColumn} TEXT,
      ${DbTexts.bookNumReviewsColumn} INTEGER,
      ${DbTexts.bookSubjectColumn} TEXT
    );
  """;

  Future<Database> get db async {
    _db ??= await _initDB();
    return _db!;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "maindb.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(createAudiofilesTable);
    await db.execute(createBooksTable);
  }

  // insert
  Future<int?> saveBook(BookModel book) async {
    try {
      var dbClient = await db;
      int result = await dbClient.insert(DbTexts.bookTable, book.toMap());
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<int> saveAudioFile(AudioFileModel audiofile) async {
    var dbClient = await db;
    int result =
        await dbClient.insert(DbTexts.audioFilesTable, audiofile.toMap());
    return result;
  }

  @override
  Future<List<BookModel>> getBooks(int offset, int limit) async {
    var dbClient = await db;
    var res = await dbClient
        .rawQuery('SELECT * FROM ${DbTexts.bookTable} LIMIT $offset,$limit');
    return BookModel.fromDbArray(res);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  @override
  Future saveBooks(List<BookModel> books) async {
    for (var book in books) {
      saveBook(book);
    }
  }

  Future<BookModel?> getBook(String? id) async {
    var dbClient = await db;
    final maps = await dbClient.query(DbTexts.bookTable,
        columns: null, where: "${DbTexts.columnId} = ?", whereArgs: [id]);

    if (maps.isNotEmpty) {
      return BookModel.fromDB(maps.first);
    }
    return null;
  }

  @override
  Future<List<AudioFileModel>> fetchAudioFiles(String? bookId) async {
    var dbClient = await db;
    var res = await dbClient.query(DbTexts.audioFilesTable,
        where: " ${DbTexts.afBookIdColumn} = ?", whereArgs: [bookId]);
    return AudioFileModel.fromDBArray(res);
  }

  @override
  Future saveAudioFiles(List<AudioFileModel> audiofiles) async {
    for (var audiofile in audiofiles) {
      saveAudioFile(audiofile);
    }
  }
}
