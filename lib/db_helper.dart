import 'dart:io'; // for Directory

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  // Singleton pattern for the database
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // If the database is null, initialize it
    _database = await _initDB();
    return _database!;
  }

  // Open the database or create it if it doesn't exist
  static Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'demo.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create table
  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT
      )
    ''');
  }

  // Insert a new item
  static Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('items', item);
  }

  // Fetch all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('items');
  }

  // Update an item
  static Future<int> updateItem(Map<String, dynamic> item, int id) async {
    final db = await database;
    return await db.update('items', item, where: 'id = ?', whereArgs: [id]);
  }

  // Delete an item
  static Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
