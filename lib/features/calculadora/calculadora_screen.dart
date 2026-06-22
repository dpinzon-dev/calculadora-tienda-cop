import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/formato_cop.dart';
import 'providers/calculator_notifier.dart';
import 'widgets/producto_card.dart';
import 'widgets/teclado_numerico.dart';

class CalculadoraScreen extends ConsumerWidget {
  const CalculadoraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            // Navegar al historial (lo conectamos en el paso 7)
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _PerfilCirculo(color: Colors.red),
            SizedBox(width: 12),
            _PerfilCirculo(color: Colors.blue),
            SizedBox(width: 12),
            _PerfilCirculo(color: Colors.green),
          ],
        ),
      ),
      body: Column(
        children: [
          // Lista de productos
          Expanded(
            child: state.productos.isEmpty
                ? const Center(child: Text('Agrega productos abajo'))
                : ListView.builder(
                    itemCount: state.productos.length,
                    itemBuilder: (context, index) {
                      final producto = state.productos[index];
                      return ProductoCard(
                        producto: producto,
                        onIncrementar: () =>
                            notifier.incrementarCantidad(producto.id),
                        onDecrementar: () =>
                            notifier.decrementarCantidad(producto.id),
                        onEliminar: () =>
                            notifier.eliminarProducto(producto.id),
                      );
                    },
                  ),
          ),

          // Barra de total
          Container(
            width: double.infinity,
            color: const Color(0xFFB2EBF2),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              formatearCOP(state.total),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
          ),

          // Fila de AC + display + AC, y debajo flechas/teclado/flechas
          Row(
            children: [
              _BotonLateral(
                texto: 'AC',
                color: Colors.red,
                onTap: notifier
                    .limpiarTodo, // luego conectamos el guardado en historial
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCEDC8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    formatearCOP(double.tryParse(state.displayActual) ?? 0),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              _BotonLateral(
                texto: 'AC',
                color: Colors.red,
                onTap: notifier.limpiarTodo,
              ),
            ],
          ),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ColumnaLateral(
                  onBackspace: notifier.borrarUltimoDigito,
                  onAgregar: notifier.agregarProducto,
                  onLimpiar: notifier.limpiarDisplay,
                ),
                Expanded(
                  child: TecladoNumerico(
                    onDigito: notifier.teclear,
                    onBackspace: notifier.borrarUltimoDigito,
                    onAgregar: notifier.agregarProducto,
                  ),
                ),
                _ColumnaLateral(
                  onBackspace: notifier.borrarUltimoDigito,
                  onAgregar: notifier.agregarProducto,
                  onLimpiar: notifier.limpiarDisplay,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PerfilCirculo extends StatelessWidget {
  final Color color;

  const _PerfilCirculo({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _BotonLateral extends StatelessWidget {
  final String texto;
  final Color color;
  final VoidCallback onTap;

  const _BotonLateral({
    required this.texto,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        onPressed: onTap,
        child: Text(texto),
      ),
    );
  }
}

class _ColumnaLateral extends StatelessWidget {
  final VoidCallback onBackspace;
  final VoidCallback onAgregar;
  final VoidCallback onLimpiar;

  const _ColumnaLateral({
    required this.onBackspace,
    required this.onAgregar,
    required this.onLimpiar,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: onBackspace,
              child: const Icon(Icons.chevron_left, color: Colors.white),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: onAgregar,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: onLimpiar,
              child: const Text('C', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
