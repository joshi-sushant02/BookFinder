// import 'package:flutter/material.dart';
import 'package:flutter_fire2/database/book_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_fire2/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? db;
  String note = 'note';
  String cover = 'cover';
  String author = 'author';
  static final booktable = "booksdb2";
  static final idd = 'id';
  static final title = "title";

  Future<Database> get database async {
    if (db != null) {
      return db!;
    }
    db = await _initDb('books3.db');
    return db!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbpath = await getApplicationDocumentsDirectory();
    final path = join(dbpath.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database _db, int version) async {
    await _db.execute('''
CREATE TABLE $booktable(
 $title TEXT NOT NULL,
 $idd INTEGER PRIMARY KEY AUTOINCREMENT,
 $note TEXT NOT NULL,
 $author TEXT NOT NULL,
 $cover TEXT NOT NULL)
 ''');
  }

  Future addbook(BookModel book) async {
    final _db = await database;
    final id = await _db.insert(booktable, book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print("book added");
  }

  Future deletebook() async {
    final _db = await database;
    final id = await _db.rawDelete(
        "DELETE FROM $booktable WHERE  id = (SELECT Max($idd) FROM $booktable) ");
    print("book deleted");
  }

  Future getbook() async {
    final _db = await database;

    var res = await _db.query(booktable);
    if (res.length == 0) {
      return Null;
    } else {
      List resultList = res.toList();
      return resultList.isNotEmpty ? resultList : Null;
    }
  }

  Future close() async {
    final _db = await database;
    _db.close();
  }
}
