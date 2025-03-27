import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelperUser {
  static Database? userDB;
  static Future<Database> getDatabase() async {
    if (userDB != null) {
      return userDB!;
    }
    userDB = await initDB();
    return userDB!;
  }
//initialize db
  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'userList.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, email TEXT)''',
        );
      },
    );
  }

  // Insert data into the db

  static Future<void> inserUsers(String name, int age, String email) async {
    final db = await getDatabase();
    await db.insert('users', {
      'name': name,
      'age': age,
      'email': email,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

    // Get all users from the db
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await getDatabase();
    return await db.query('users');
  }

  // Close the db
  static Future<void> close() async {
    final db = await getDatabase();
    db.close();
  }


}
