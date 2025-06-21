import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../model/event_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'users.db');

    return openDatabase(
      path,
      version: 2,                       //  <<< bump the version
      onCreate: (db, _) async {
        await _createUserTable(db);
        await _createEventsTable(db);
      },
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) await _createEventsTable(db);
      },
    );
  }

  Future<void> _createUserTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  Future<void> _createEventsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        category TEXT,
        description TEXT,
        banner TEXT,
        date INTEGER
      )
    ''');
  }

  Future<int> addEvent(Event e) async =>
      (await database).insert('events', e.toMap());

  Future<List<Event>> fetchEvents() async {
    final rows = await (await database)
        .query('events', orderBy: 'date DESC');
    return rows.map(Event.fromMap).toList();
  }

  Future<int> insertUser(String email, String password) async{
    final db = await database;
    return await db.insert('users', {'email' : email, 'password' : password});
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query('users', where: 'email =? AND password = ?', whereArgs: [email, password]);
    return result.isNotEmpty ? result.first : null;
  }
}
