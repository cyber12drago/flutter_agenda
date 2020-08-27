import 'dart:core';
import 'dart:async';
import 'package:agenda/domain/worker.dart';
import 'package:agenda/model/model_provider.dart';
import 'package:agenda/util/enums.dart';

class WorkerRepository {
  static const String tableName = 'Agenda';
  final ModelProvider modelProvider;

  WorkerRepository(this.modelProvider);

  Future<int> create(Worker domain) {
    final agenda = domain.toMap();
    print('[db] is creating $agenda');
    return modelProvider
        .getDatabase()
        .then((database) => database.insert(tableName, agenda));
  }

  Future<List<Worker>> findAll([String searchCriteria]) {
    var sql = '''
    SELECT
        id_agenda AS id,
        task_name AS taskName,
        waktu_mulai AS waktuMulai,
        waktu_selesai AS waktuSelesai,
        lokasi,
        alarm,
        deskripsi,
        notulensi,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM
        $tableName
    ''';

    if (searchCriteria.isNotEmpty) {
      final pattern = '%$searchCriteria%';
      sql += '''
      WHERE
        task_name LIKE '$pattern' OR
        lokasi LIKE '$pattern' OR
      ''';
    }
    sql += 'ORDER BY waktu_mulai ASC;';
    print('[db] raw sql: $sql');
    return modelProvider
        .getDatabase()
        .then((database) => database.rawQuery(sql))
        .then((data) {
      print('[db] success retrieve $data');
      if (data.length == 0) {
        return [];
      }
      final List<Worker> workers = [];
      for (var i = 0; i < data.length; i++) {
        Worker worker = Worker();
        worker.fromMap(data[i]);
        workers.add(worker);
      }

      return workers;
    });
  }

  Future<Worker> findOne(int id) {
    final sql = '''
      SELECT
        id_agenda AS id,
        task_name AS taskName,
        waktu_mulai AS waktuMulai,
        waktu_selesai AS waktuSelesai,
        lokasi,
        alarm,
        deskripsi,
        notulensi,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM
        $tableName
      WHERE id_agenda = $id;
    ''';
    return modelProvider
        .getDatabase()
        .then((database) => database.rawQuery(sql))
        .then((data) {
      print('[db] success retrieve $data by id = $id');
      if (data.length == 1) {
        final Worker worker = Worker();
        worker.fromMap(data[0]);

        return worker;
      }

      return null;
    });
  }

  Future<int> delete(int id) {
    return modelProvider.getDatabase().then((database) =>
        database.delete(tableName, where: 'id_agenda = ?', whereArgs: [id]));
  }

  Future<int> rawdelete(int id) {
    const sql = 'DELETE FROM $tableName WHERE id_agenda = ?';
    return modelProvider
        .getDatabase()
        .then((database) => database.rawDelete(sql, [id]));
  }

  Future<int> update(int id, Worker domain) {
    print('[db] Updating data by id from the db...');
    return modelProvider.getDatabase().then((database) => database.update(
        tableName, domain.toMap(Purpose.updated),
        where: 'id_siswa = $id'));
  }
}