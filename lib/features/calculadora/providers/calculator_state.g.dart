// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculator_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculatorStateAdapter extends TypeAdapter<CalculatorState> {
  @override
  final int typeId = 3;

  @override
  CalculatorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculatorState(
      productos: (fields[0] as List).cast<Producto>(),
      displayActual: fields[1] as String,
      origenId: fields[2] as String?,
      modificado: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CalculatorState obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.productos)
      ..writeByte(1)
      ..write(obj.displayActual)
      ..writeByte(2)
      ..write(obj.origenId)
      ..writeByte(3)
      ..write(obj.modificado);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculatorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
