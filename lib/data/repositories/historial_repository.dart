import 'package:hive/hive.dart';
import '../models/calculo.dart';

class HistorialRepository {
  static const _nombreCaja = 'historial';
  static const _diasExpiracion = 7;

  Future<Box<Calculo>> _abrirCaja() {
    return Hive.openBox<Calculo>(_nombreCaja);
  }

  Future<void> guardar(Calculo calculo) async {
    final caja = await _abrirCaja();
    await caja.put(calculo.id, calculo);
  }

  Future<List<Calculo>> listarTodos() async {
    final caja = await _abrirCaja();
    final lista = caja.values.toList();
    lista.sort((a, b) => b.fecha.compareTo(a.fecha)); // más reciente primero
    return lista;
  }

  Future<Calculo?> buscarPorId(String id) async {
    final caja = await _abrirCaja();
    return caja.get(id);
  }

  /// Elimina del historial los cálculos con más de 7 días de antigüedad.
  Future<void> limpiarExpirados() async {
    final caja = await _abrirCaja();
    final limite = DateTime.now().subtract(const Duration(days: _diasExpiracion));

    final idsExpirados = caja.values
        .where((calculo) => calculo.fecha.isBefore(limite))
        .map((calculo) => calculo.id)
        .toList();

    for (final id in idsExpirados) {
      await caja.delete(id);
    }
  }
}