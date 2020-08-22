import 'package:sqflite/sqflite.dart';

class Model {
  Future<void> onConfigure(Database db) async {
    print('[db] configure version ${await db.getVersion()}');
  }

  Future<void> onOpen(Database db, int version) async {
    print('[db] open version ${await db.getVersion()}');
  }

  Future<void> onCreate(Database db, int version) async {
    print('[db] create version ${version.toString()}');
    final sql = '''
      CREATE TABLE IF NOT EXISTS Agenda (
        id_agenda INTEGER PRIMARY KEY NOT NULL,
        task_name TEXT(30),
        waktu_mulai TEXT(30),
        waktu_selesai TEXT(30),
        lokasi TEXT(50),
        alarm TEXT(10),
        deskripsi TEXT(100),
        notulensi TEXT(100),
        created_at TEXT,
        updated_at TEXT
      );
    ''';
    await db.execute(sql);
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('[db] oldVersion $oldVersion');
    print('[db] newVersion $newVersion');
    if (newVersion > oldVersion) {
      // TODO: place migration script here
    }
  }

  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    print('[db] oldVersion $oldVersion');
    print('[db] newVersion $newVersion');
    if (newVersion < oldVersion) {
      // TODO: place migration script here
    }
  }
}