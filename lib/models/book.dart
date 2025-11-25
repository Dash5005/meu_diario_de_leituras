import 'package:hive/hive.dart';
import 'annotation.dart';
import 'review.dart';
part 'book.g.dart';

@HiveType(typeId: 0)
class Livro extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String titulo;

  @HiveField(2)
  String autor;

  @HiveField(3)
  String genero;

  @HiveField(4)
  List<Anotacao> anotacoes;

  @HiveField(5)
  List<Review> avaliacoes;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
    List<Anotacao>? anotacoes,
    List<Review>? avaliacoes,
  }) : anotacoes = anotacoes ?? [],
       avaliacoes = avaliacoes ?? [];
}
