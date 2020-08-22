abstract class Domain {
  int id;
  DateTime createdAt;
  DateTime updatedAt;

  fromMap(Map<String, dynamic>value);
  Map<String,dynamic> toMap();
}