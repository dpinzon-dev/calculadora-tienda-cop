import '../../../data/models/producto.dart';

class CalculatorState {
  final List<Producto> productos;
  final String displayActual; // lo que se está tecleando

  const CalculatorState({
    this.productos = const [],
    this.displayActual = '0',
  });

  double get total => productos.fold(0, (sum, p) => sum + p.total);

  CalculatorState copyWith({
    List<Producto>? productos,
    String? displayActual,
  }) {
    return CalculatorState(
      productos: productos ?? this.productos,
      displayActual: displayActual ?? this.displayActual,
    );
  }
}