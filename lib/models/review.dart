import 'package:hive/hive.dart';

part 'review.g.dart';

@HiveType(typeId: 2)
class Review {
  @HiveField(0)
  String id;
  @HiveField(1)
  int nota;
  @HiveField(2)
  String comentario;
  @HiveField(3)
  DateTime data;

  Review({
    required this.id,
    required this.nota,
    required this.comentario,
    required this.data,
  });
}
