import 'package:hive/hive.dart';

part 'perfil_color.g.dart';

@HiveType(typeId: 2)
enum PerfilColor {
  @HiveField(0)
  rojo,
  @HiveField(1)
  azul,
  @HiveField(2)
  verde,
}