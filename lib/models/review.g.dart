// GENERATED ADAPTER (manual)

part of 'review.dart';

class ReviewAdapter extends TypeAdapter<Review> {
  @override
  final int typeId = 2;

  @override
  Review read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Review(
      id: fields[0] as String,
      nota: fields[1] as int,
      comentario: fields[2] as String,
      data: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Review obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nota)
      ..writeByte(2)
      ..write(obj.comentario)
      ..writeByte(3)
      ..write(obj.data);
  }
}
