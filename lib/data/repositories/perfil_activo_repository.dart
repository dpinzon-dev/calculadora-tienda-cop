
import 'package:hive/hive.dart';
import '../models/perfil_color.dart';

class PerfilActivoRepository {
  static const _nombreCaja = 'preferencias';
  static const _clave = 'perfil_activo';

  Future<Box> _abrirCaja() => Hive.openBox(_nombreCaja);

  Future<void> guardar(PerfilColor perfil) async {
    final caja = await _abrirCaja();
    await caja.put(_clave, perfil.name);
  }

  Future<PerfilColor> leer() async {
    final caja = await _abrirCaja();
    final nombre = caja.get(_clave) as String?;
    if (nombre == null) return PerfilColor.rojo; // primera vez -> rojo
    return PerfilColor.values.firstWhere((p) => p.name == nombre);
  }
}