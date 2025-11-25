// GENERATED ADAPTER (manual)

part of 'annotation.dart';

class AnotacaoAdapter extends TypeAdapter<Anotacao> {
  @override
  final int typeId = 1;

  @override
  Anotacao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Anotacao(
      id: fields[0] as String,
      texto: fields[1] as String,
      pagina: fields[2] as int,
      data: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Anotacao obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.texto)
      ..writeByte(2)
      ..write(obj.pagina)
      ..writeByte(3)
      ..write(obj.data);
  }
}
