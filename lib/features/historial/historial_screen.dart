import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/formato_cop.dart';
import '../../data/models/calculo.dart';
import '../../data/models/perfil_color.dart';
import '../../data/repositories/historial_repository.dart';
import '../calculadora/providers/calculator_notifier.dart';
import '../calculadora/providers/perfil_activo_provider.dart';
import '../credits/credits_screen.dart';

final historialProvider = FutureProvider.autoDispose<List<Calculo>>((ref) async {
  return HistorialRepository().listarTodos();
});

Color _colorDePerfil(PerfilColor perfil) {
  switch (perfil) {
    case PerfilColor.rojo:
      return Colors.red;
    case PerfilColor.azul:
      return Colors.blue;
    case PerfilColor.verde:
      return Colors.green;
  }
}

class HistorialScreen extends ConsumerWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historialAsync = ref.watch(historialProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de cálculos', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreditsScreen()),
            ),
          ),
        ],
      ),
      body: historialAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, _) => Center(
          child: Text('Error al cargar: $err', style: const TextStyle(color: Colors.white)),
        ),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Text('Aún no hay cálculos guardados', style: TextStyle(color: Colors.white)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final calculo = lista[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _colorDePerfil(calculo.perfil),
                    radius: 10,
                  ),
                  title: Text(
                    formatearCOP(calculo.total),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${calculo.productos.length} producto(s) · '
                        '${calculo.fecha.day}/${calculo.fecha.month}/${calculo.fecha.year}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  onTap: () => _abrirDetalle(context, ref, calculo),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _abrirDetalle(BuildContext context, WidgetRef ref, Calculo calculo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _DetalleCalculoSheet(calculo: calculo),
    );
  }
}

class _DetalleCalculoSheet extends ConsumerWidget {
  final Calculo calculo;

  const _DetalleCalculoSheet({required this.calculo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatearCOP(calculo.total),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...calculo.productos.map((p) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${formatearCOP(p.valorUnitario)} x${p.cantidad}'),
                Text(formatearCOP(p.total)),
              ],
            ),
          )),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorDePerfil(calculo.perfil),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Cambiamos al perfil correspondiente y cargamos el cálculo en modo edición
                    ref.read(perfilActivoProvider.notifier).cambiarA(calculo.perfil);
                    ref.read(calculatorProvider(calculo.perfil).notifier).cargarParaEditar(calculo);

                    Navigator.pop(context); // cierra el bottom sheet
                    Navigator.pop(context); // cierra la pantalla de historial, vuelve a la calculadora
                  },
                  child: const Text('Editar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}