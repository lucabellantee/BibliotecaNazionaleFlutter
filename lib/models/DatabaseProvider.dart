import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dbbooks.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() {
    return _instance;
  }

  Database? _database;

  DatabaseProvider._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    final String path = join(await getDatabasesPath(), 'my_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            password TEXT NOT NULL,
            isLogged INTEGER CHECK(isLogged IN (0, 1))
          )
        ''');

        await db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            authors TEXT NOT NULL,
            image TEXT,
            description TEXT
          )
        ''');
      },
    );
  }

  Future<void> registerUser(String email, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'email': email,
        'password': password,
        'isLogged': 0,
      },
    );
  }

  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  Future<void> logoutUser(int userId) async {
    final db = await database;
    await db.update(
      'users',
      {'isLogged': 0},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> removeUser(int userId) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> updateUserData(int userId, String newEmail, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {
        'email': newEmail,
        'password': newPassword,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>> getUserDataByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return {};
  }

  Future<List<Map<String, dynamic>>> getAllUserData() async {
    final db = await database;
    return db.query('users');
  }

  Future<void> addBook(DBBook book) async {
    final db = await database;
    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateBook(DBBook book) async {
    final db = await database;
    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(int bookId) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }
}