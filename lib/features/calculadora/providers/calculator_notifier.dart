import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/producto.dart';
import 'calculator_state.dart';

const _uuid = Uuid();

class CalculatorNotifier extends Notifier<CalculatorState> {
  @override
  CalculatorState build() => const CalculatorState();

  /// El usuario teclea un número (botón del teclado numérico)
  void teclear(String digito) {
    final actual = state.displayActual == '0' ? '' : state.displayActual;
    state = state.copyWith(displayActual: actual + digito);
  }

  /// Botón "+" grande: agrega el valor del display como nuevo producto
  void agregarProducto() {
    final valor = double.tryParse(state.displayActual) ?? 0;
    if (valor <= 0) return;

    final nuevoProducto = Producto(
      id: _uuid.v4(),
      valorUnitario: valor,
      cantidad: 1,
    );

    state = state.copyWith(
      productos: [...state.productos, nuevoProducto],
      displayActual: '0',
    );
  }

  /// Botón "+" de una tarjeta: incrementa cantidad
  void incrementarCantidad(String productoId) {
    state = state.copyWith(
      productos: state.productos.map((p) {
        return p.id == productoId ? p.copyWith(cantidad: p.cantidad + 1) : p;
      }).toList(),
    );
  }

  /// Botón "-" de una tarjeta: decrementa cantidad (mínimo 1)
  void decrementarCantidad(String productoId) {
    state = state.copyWith(
      productos: state.productos.map((p) {
        if (p.id == productoId && p.cantidad > 1) {
          return p.copyWith(cantidad: p.cantidad - 1);
        }
        return p;
      }).toList(),
    );
  }

  /// Caneca: elimina un producto de la lista
  void eliminarProducto(String productoId) {
    state = state.copyWith(
      productos: state.productos.where((p) => p.id != productoId).toList(),
    );
  }

  /// Botón C: limpia solo el display actual
  void limpiarDisplay() {
    state = state.copyWith(displayActual: '0');
  }

  /// Botón AC: limpia todo (el guardado en historial lo conectamos en el paso 6)
  void limpiarTodo() {
    state = const CalculatorState();
  }

  /// Botón "<": borra el último dígito tecleado (backspace)
  void borrarUltimoDigito() {
    final actual = state.displayActual;
    if (actual.length <= 1) {
      state = state.copyWith(displayActual: '0');
    } else {
      state = state.copyWith(displayActual: actual.substring(0, actual.length - 1));
    }
  }


}

final calculatorProvider = NotifierProvider<CalculatorNotifier, CalculatorState>(
  CalculatorNotifier.new,
);
