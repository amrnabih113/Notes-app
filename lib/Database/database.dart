import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initdb();
    }
    return _db;
  }

  Future<Database> initdb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'nabih.db');
    Database mydb = await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("onubgrade");
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "USERS" (
        "ID" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "NAME" TEXT NOT NULL,
        "EMAIL" TEXT NOT NULL UNIQUE,
        "PASSWORD" TEXT NOT NULL
      )
    ''');
    print("Database and USERS table created");

    await db.execute('''
      CREATE TABLE "NOTES" (
        "ID" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "TITLE" TEXT NOT NULL,
        "NOTE" TEXT NOT NULL,
        "COLOR" TEXT NOT NULL,
        "DATE" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        "USER_ID" INT NOT NULL,
        FOREIGN KEY ("USER_ID") REFERENCES "USERS"("ID")
      )
    ''');
    print("Notes table created");
  }

  Future<int> insert(String sql, List<dynamic> arguments) async {
    Database? mydb = await db;
    if (mydb == null) {
      throw StateError("Database is not initialized");
    }
    return await mydb.rawInsert(sql, arguments);
  }

  Future<List<Map<String, dynamic>>> getdata(String sql, [List<dynamic>? arguments]) async {
    Database? mydb = await db;
    if (mydb == null) {
      throw StateError("Database is not initialized");
    }
    return await mydb.rawQuery(sql, arguments);
  }

  Future<int> delete(String sql, [List<dynamic>? arguments]) async {
    Database? mydb = await db;
    if (mydb == null) {
      throw StateError("Database is not initialized");
    }
    return await mydb.rawDelete(sql, arguments);
  }

  Future<int> update(String sql, [List<dynamic>? arguments]) async {
    Database? mydb = await db;
    if (mydb == null) {
      throw StateError("Database is not initialized");
    }
    return await mydb.rawUpdate(sql, arguments);
  }

  Future<void> close() async {
    Database? mydb = await db;
    if (mydb != null) {
      await mydb.close();
      _db = null; // Set _db to null after closing
    }
  }
}
