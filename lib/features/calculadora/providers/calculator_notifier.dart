import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/calculo.dart';
import '../../../data/models/color_resaltado.dart';
import '../../../data/models/perfil_color.dart';
import '../../../data/models/producto.dart';
import '../../../data/repositories/estado_calculadora_repository.dart';
import '../../../data/repositories/historial_repository.dart';
import 'calculator_state.dart';

const _uuid = Uuid();

class CalculatorNotifier extends FamilyNotifier<CalculatorState, PerfilColor> {
  final _repository = EstadoCalculadoraRepository();
  final _historialRepository = HistorialRepository();

  PerfilColor get _perfil => arg;

  @override
  CalculatorState build(PerfilColor arg) {
    _restaurarEstado();
    return CalculatorState();
  }

  Future<void> _restaurarEstado() async {
    try {
      final guardado = await _repository.leer(_perfil);
      if (guardado != null) {
        state = guardado;
      }
    } catch (e) {
      // ignore: avoid_print
      print('No se pudo restaurar el estado del perfil $_perfil: $e');
    }
  }

  Future<void> _persistir() async {
    await _repository.guardar(_perfil, state);
  }

  void _guardarEnHistorialSiAplica() {
    final esCalculoNuevo = state.origenId == null;
    final debeGuardar =
        state.productos.isNotEmpty && (esCalculoNuevo || state.modificado);

    if (debeGuardar) {
      final calculo = Calculo(
        id: _uuid.v4(),
        origenId: state.origenId,
        productos: List.from(state.productos),
        total: state.total,
        fecha: DateTime.now(),
        perfil: _perfil,
      );
      _historialRepository.guardar(calculo);
    }
  }

  void teclear(String digito) {
    final actual = state.displayActual == '0' ? '' : state.displayActual;
    state = state.copyWith(displayActual: actual + digito);
    _persistir();
  }

  /// Botón "X": guarda el precio actual como pendiente y limpia el display
  /// para que el usuario teclee la cantidad.
  void multiplicacion() {
    if (state.enModoMultiplicar) return;
    final valor = double.tryParse(state.displayActual) ?? 0;
    if (valor <= 0) return;

    state = state.copyWith(
      displayActual: '0',
      valorPendienteMultiplicacion: valor,
    );
    _persistir();
  }


  void agregarProducto() {
    if (state.enModoMultiplicar) {
      final cantidad = int.tryParse(state.displayActual) ?? 0;
      if (cantidad <= 0) return;

      final nuevoProducto = Producto(
        id: _uuid.v4(),
        valorUnitario: state.valorPendienteMultiplicacion!,
        cantidad: cantidad,
      );

      state = state.copyWith(
        productos: [...state.productos, nuevoProducto],
        displayActual: '0',
        limpiarPendiente: true,
        modificado: true,
      );
      _persistir();
      return;
    }

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
      modificado: true,
    );
    _persistir();
  }

  void incrementarCantidad(String productoId) {
    state = state.copyWith(
      productos: state.productos.map((p) {
        return p.id == productoId ? p.copyWith(cantidad: p.cantidad + 1) : p;
      }).toList(),
      modificado: true,
    );
    _persistir();
  }

  void decrementarCantidad(String productoId) {
    state = state.copyWith(
      productos: state.productos.map((p) {
        if (p.id == productoId && p.cantidad > 1) {
          return p.copyWith(cantidad: p.cantidad - 1);
        }
        return p;
      }).toList(),
      modificado: true,
    );
    _persistir();
  }

  void eliminarProducto(String productoId) {
    state = state.copyWith(
      productos: state.productos.where((p) => p.id != productoId).toList(),
      modificado: true,
    );
    _persistir();
  }

  void cambiarResaltado(String productoId, ColorResaltado color) {
    state = state.copyWith(
      productos: state.productos.map((p) {
        if (p.id != productoId) return p;
        final nuevoColor =
        p.resaltado == color ? ColorResaltado.ninguno : color;
        return p.copyWith(resaltado: nuevoColor);
      }).toList(),
      modificado: true,
    );
    _persistir();
  }

  void borrarUltimoDigito() {
    if (state.enModoMultiplicar && state.displayActual == '0') {
      // Cancela la multiplicación y restaura el precio original en el display
      state = state.copyWith(
        displayActual: state.valorPendienteMultiplicacion!.toInt().toString(),
        limpiarPendiente: true,
      );
      _persistir();
      return;
    }

    final actual = state.displayActual;
    if (actual.length <= 1) {
      state = state.copyWith(displayActual: '0');
    } else {
      state = state.copyWith(displayActual: actual.substring(0, actual.length - 1));
    }
    _persistir();
  }

  /// Botón "C": limpia el display y cancela la multiplicación pendiente si la hay.
  void limpiarDisplay() {
    state = state.copyWith(displayActual: '0', limpiarPendiente: true);
    _persistir();
  }

  void limpiarTodo() {
    _guardarEnHistorialSiAplica();
    state = CalculatorState();
    _persistir();
  }

  void cargarParaEditar(Calculo calculo) {
    _guardarEnHistorialSiAplica();
    state = CalculatorState(
      productos: List.from(calculo.productos),
      displayActual: '0',
      origenId: calculo.id,
      modificado: false,
    );
    _persistir();
  }
}

final calculatorProvider =
NotifierProvider.family<CalculatorNotifier, CalculatorState, PerfilColor>(
  CalculatorNotifier.new,
);