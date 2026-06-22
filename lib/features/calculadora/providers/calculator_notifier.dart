import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/calculo.dart';
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
      // Si el formato guardado es incompatible (ej: cambiamos el modelo),
      // simplemente arrancamos con el estado vacío en vez de romper la app.
      // ignore: avoid_print
      print('No se pudo restaurar el estado del perfil $_perfil: $e');
    }
  }

  Future<void> _persistir() async {
    await _repository.guardar(_perfil, state);
  }

  /// Guarda el cálculo actual en el historial, solo si corresponde:
  /// - Es un cálculo nuevo (sin origenId) con productos.
  /// - O es una edición (con origenId) que sí fue modificada.
  void _guardarEnHistorialSiAplica() {
    final esCalculoNuevo = state.origenId == null;
    final debeGuardar = state.productos.isNotEmpty &&
        (esCalculoNuevo || state.modificado);

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

  void borrarUltimoDigito() {
    final actual = state.displayActual;
    if (actual.length <= 1) {
      state = state.copyWith(displayActual: '0');
    } else {
      state = state.copyWith(displayActual: actual.substring(0, actual.length - 1));
    }
    _persistir();
  }

  void limpiarDisplay() {
    state = state.copyWith(displayActual: '0');
    _persistir();
  }

  /// Botón AC
  void limpiarTodo() {
    _guardarEnHistorialSiAplica();
    state = CalculatorState();
    _persistir();
  }

  /// Carga un cálculo del historial en modo edición.
  /// Si había algo sin guardar en este perfil, se guarda primero (como un AC implícito).
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