import 'package:hive/hive.dart';
import '../../../data/models/producto.dart';

part 'calculator_state.g.dart';

@HiveType(typeId: 3)
class CalculatorState extends HiveObject {
  @HiveField(0)
  final List<Producto> productos;

  @HiveField(1)
  final String displayActual;

  @HiveField(2)
  final String? origenId;

  @HiveField(3)
  final bool modificado;

  CalculatorState({
    this.productos = const [],
    this.displayActual = '0',
    this.origenId,
    this.modificado = false,
  });

  double get total => productos.fold(0, (sum, p) => sum + p.total);

  CalculatorState copyWith({
    List<Producto>? productos,
    String? displayActual,
    String? origenId,
    bool? modificado,
  }) {
    return CalculatorState(
      productos: productos ?? this.productos,
      displayActual: displayActual ?? this.displayActual,
      origenId: origenId ?? this.origenId,
      modificado: modificado ?? this.modificado,
    );
  }
}