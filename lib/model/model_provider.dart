import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

ModelProvider _modelProvider;

class ModelProvider {
  static ModelProvider getInstance() {
    if (_modelProvider != null && _modelProvider is ModelProvider) {
      return _modelProvider;
    }

    _modelProvider =
        ModelProvider(dbName: '_agendaku_flutter.db', dbVersion: 1);

    return _modelProvider;
  }
  final String dbName;
  final int dbVersion;
  Database _database;

  ModelProvider({this.dbName, this.dbVersion});

  Future<Database> open() async {
    var databasesPath = await getDatabasesPath();
    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {
      print('[directory] already exist');
    }

    final path = join(databasesPath, dbName);
    final model = Model();
    _database = await openDatabase(
      path,
      version: dbVersion,
      onConfigure: model.onConfigure,
      onCreate: model.onCreate,
      onUpgrade: model.onUpgrade,
      onDowngrade: model.onDowngrade,
    );

    return _database;
  }

  Future<void> close() {
    return getDatabase().then((database) => database.close());
  }

  Future<Database> getDatabase() async {
    if (_database == null) throw 'You forgot to open database!';
    return _database;
  }
}