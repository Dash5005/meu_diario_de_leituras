// GENERATED ADAPTER (manual)

part of 'book.dart';

class LivroAdapter extends TypeAdapter<Livro> {
  @override
  final int typeId = 0;

  @override
  Livro read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Livro(
      id: fields[0] as String,
      titulo: fields[1] as String,
      autor: fields[2] as String,
      genero: fields[3] as String,
      anotacoes: (fields[4] as List?)?.cast<Anotacao>(),
      avaliacoes: (fields[5] as List?)?.cast<Review>(),
    );
  }

  @override
  void write(BinaryWriter writer, Livro obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titulo)
      ..writeByte(2)
      ..write(obj.autor)
      ..writeByte(3)
      ..write(obj.genero)
      ..writeByte(4)
      ..write(obj.anotacoes)
      ..writeByte(5)
      ..write(obj.avaliacoes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LivroAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
