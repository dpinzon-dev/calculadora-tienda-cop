import 'package:hive/hive.dart';

part 'producto.g.dart';

@HiveType(typeId: 0)
class Producto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double valorUnitario;

  @HiveField(2)
  final int cantidad;

  Producto({
    required this.id,
    required this.valorUnitario,
    required this.cantidad,
  });

  double get total => valorUnitario * cantidad;

  Producto copyWith({int? cantidad}) {
    return Producto(
      id: id,
      valorUnitario: valorUnitario,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}