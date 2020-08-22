import 'package:agenda/domain/domain.dart';
import 'package:agenda/util/enums.dart';

class Worker extends Domain {
  static const alarms = ['None','1 Jam sebelum', '30 Menit Sebelum', '15 Menit Sebelum', '10 menit Sebelum','5 menit Sebelum'];

  String taskName;
  String waktuMulai;
  String waktuSelesai;
  String lokasi;
  String deskripsi;
  String notulensi;
  String alarm;

  @override
  Map<String, dynamic> toMap([Purpose purpose = Purpose.created]) {
    var map = <String, dynamic>{
      'task_name': taskName,
      'waktu_mulai': waktuMulai,
      'waktu_selesai': waktuSelesai,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'notulensi': notulensi,
      'alarm':alarm,
    };
    if (id != null) {
      map['id_worker'] = id;
    }
    if (purpose == Purpose.created && createdAt == null) {
      map['created_at'] = DateTime.now().toIso8601String();
    }
    if (purpose == Purpose.updated && updatedAt == null) {
      map['updated_at'] = DateTime.now().toIso8601String();
    }

    return map;
  }

  @override
  void fromMap(Map<String, dynamic> value) {
    taskName = value['taskName'];
    waktuMulai = value['waktuMulai'];
    waktuSelesai = value['waktuSelesai'];
    lokasi= value['lokasi'];
    deskripsi= value['deskripsi'];
    notulensi= value['notulensi'];
    alarm = value['alarm'];
    id = value['id'];
    createdAt = value['createdAt'] is String
        ? DateTime.parse(value['createdAt'])
        : null;
    updatedAt = value['updatedAt'] is String
        ? DateTime.parse(value['updatedAt'])
        : null;
  }
}