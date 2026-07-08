// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculoAdapter extends TypeAdapter<Calculo> {
  @override
  final int typeId = 1;

  @override
  Calculo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Calculo(
      id: fields[0] as String,
      origenId: fields[1] as String?,
      productos: (fields[2] as List).cast<Producto>(),
      total: fields[3] as double,
      fecha: fields[4] as DateTime,
      perfil: fields[5] as PerfilColor,
    );
  }

  @override
  void write(BinaryWriter writer, Calculo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.origenId)
      ..writeByte(2)
      ..write(obj.productos)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.fecha)
      ..writeByte(5)
      ..write(obj.perfil);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
