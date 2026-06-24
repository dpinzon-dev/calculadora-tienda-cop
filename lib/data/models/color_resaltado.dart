import 'package:hive/hive.dart';

part 'color_resaltado.g.dart';

@HiveType(typeId: 4)
enum ColorResaltado {
  @HiveField(0)
  ninguno,
  @HiveField(1)
  amarillo,
  @HiveField(2)
  morado,
  @HiveField(3)
  naranja,
}