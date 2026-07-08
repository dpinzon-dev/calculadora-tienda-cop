// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_color.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PerfilColorAdapter extends TypeAdapter<PerfilColor> {
  @override
  final int typeId = 2;

  @override
  PerfilColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PerfilColor.rojo;
      case 1:
        return PerfilColor.azul;
      case 2:
        return PerfilColor.verde;
      default:
        return PerfilColor.rojo;
    }
  }

  @override
  void write(BinaryWriter writer, PerfilColor obj) {
    switch (obj) {
      case PerfilColor.rojo:
        writer.writeByte(0);
        break;
      case PerfilColor.azul:
        writer.writeByte(1);
        break;
      case PerfilColor.verde:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerfilColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
