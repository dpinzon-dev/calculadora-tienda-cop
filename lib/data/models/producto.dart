import 'package:hive/hive.dart';
import 'color_resaltado.dart';

part 'producto.g.dart';

@HiveType(typeId: 0)
class Producto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double valorUnitario;

  @HiveField(2)
  final int cantidad;

  @HiveField(3)
  final ColorResaltado resaltado;

  Producto({
    required this.id,
    required this.valorUnitario,
    required this.cantidad,
    this.resaltado = ColorResaltado.ninguno,
  });

  double get total => valorUnitario * cantidad;

  Producto copyWith({int? cantidad, ColorResaltado? resaltado}) {
    return Producto(
      id: id,
      valorUnitario: valorUnitario,
      cantidad: cantidad ?? this.cantidad,
      resaltado: resaltado ?? this.resaltado,
    );
  }
}