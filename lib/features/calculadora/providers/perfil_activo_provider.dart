import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/perfil_color.dart';
import '../../../data/repositories/perfil_activo_repository.dart';

class PerfilActivoNotifier extends Notifier<PerfilColor> {
  final _repository = PerfilActivoRepository();

  @override
  PerfilColor build() {
    _restaurar();
    return PerfilColor.rojo; // valor inicial mientras carga
  }

  Future<void> _restaurar() async {
    final guardado = await _repository.leer();
    state = guardado;
  }

  void cambiarA(PerfilColor perfil) {
    state = perfil;
    _repository.guardar(perfil);
  }
}

final perfilActivoProvider = NotifierProvider<PerfilActivoNotifier, PerfilColor>(
  PerfilActivoNotifier.new,
);