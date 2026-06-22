import 'package:hive/hive.dart';
import 'producto.dart';
import 'perfil_color.dart';

part 'calculo.g.dart';

@HiveType(typeId: 1)
class Calculo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? origenId;

  @HiveField(2)
  final List<Producto> productos;

  @HiveField(3)
  final double total;

  @HiveField(4)
  final DateTime fecha;

  @HiveField(5)
  final PerfilColor perfil;

  Calculo({
    required this.id,
    this.origenId,
    required this.productos,
    required this.total,
    required this.fecha,
    required this.perfil,
  });
}