import 'package:hive/hive.dart';
import '../../features/calculadora/providers/calculator_state.dart';
import '../models/perfil_color.dart';

class EstadoCalculadoraRepository {
  static const _nombreCaja = 'estado_calculadora';

  Future<Box<CalculatorState>> _abrirCaja() {
    return Hive.openBox<CalculatorState>(_nombreCaja);
  }

  Future<void> guardar(PerfilColor perfil, CalculatorState estado) async {
    final caja = await _abrirCaja();
    await caja.put(perfil.name, estado);
  }

  Future<CalculatorState?> leer(PerfilColor perfil) async {
    final caja = await _abrirCaja();
    return caja.get(perfil.name);
  }
}