// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_resaltado.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorResaltadoAdapter extends TypeAdapter<ColorResaltado> {
  @override
  final int typeId = 4;

  @override
  ColorResaltado read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ColorResaltado.ninguno;
      case 1:
        return ColorResaltado.amarillo;
      case 2:
        return ColorResaltado.morado;
      case 3:
        return ColorResaltado.naranja;
      default:
        return ColorResaltado.ninguno;
    }
  }

  @override
  void write(BinaryWriter writer, ColorResaltado obj) {
    switch (obj) {
      case ColorResaltado.ninguno:
        writer.writeByte(0);
        break;
      case ColorResaltado.amarillo:
        writer.writeByte(1);
        break;
      case ColorResaltado.morado:
        writer.writeByte(2);
        break;
      case ColorResaltado.naranja:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorResaltadoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
