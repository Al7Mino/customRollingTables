import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('options.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      // Use web implementation on the web.
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      // Use ffi on Linux and Windows.
      if (Platform.isLinux || Platform.isWindows) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Table des "tables"
    await db.execute('''
      CREATE TABLE tables (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        name       TEXT    NOT NULL
      )
    ''');

    // Table des options — référence tables(id) en CASCADE
    await db.execute('''
      CREATE TABLE options (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        table_id   INTEGER NOT NULL REFERENCES tables(id) ON DELETE CASCADE,
        name       TEXT    NOT NULL,
        score      INTEGER NOT NULL DEFAULT 1,
        is_locked  INTEGER NOT NULL DEFAULT 0,
        sort_order INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Données d'exemple : 2 tables avec 3 options chacune
    for (int t = 0; t < 2; t++) {
      final tableId = await db.insert('tables', {'name': 'Table ${t + 1}'});
      for (int i = 0; i < 3; i++) {
        await db.insert('options', {
          'table_id': tableId,
          'name': 'Option ${i + 1}',
          'score': (i * 4 + t * 2 + 1).clamp(1, 20),
          'is_locked': 0,
          'sort_order': i,
        });
      }
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
