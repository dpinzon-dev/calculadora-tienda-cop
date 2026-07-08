// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductoAdapter extends TypeAdapter<Producto> {
  @override
  final int typeId = 0;

  @override
  Producto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Producto(
      id: fields[0] as String,
      valorUnitario: fields[1] as double,
      cantidad: fields[2] as int,
      resaltado: fields[3] as ColorResaltado,
    );
  }

  @override
  void write(BinaryWriter writer, Producto obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.valorUnitario)
      ..writeByte(2)
      ..write(obj.cantidad)
      ..writeByte(3)
      ..write(obj.resaltado);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
