import 'package:hive/hive.dart';
part 'annotation.g.dart';

@HiveType(typeId: 1)
class Anotacao {
  @HiveField(0)
  String id;

  @HiveField(1)
  String texto;

  @HiveField(2)
  int pagina;

  @HiveField(3)
  DateTime data;

  Anotacao({
    required this.id,
    required this.texto,
    required this.pagina,
    required this.data,
  });
}
