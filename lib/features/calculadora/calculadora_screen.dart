import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/formato_cop.dart';
import 'providers/calculator_notifier.dart';
import 'widgets/producto_card.dart';
import 'widgets/teclado_numerico.dart';

class CalculadoraScreen extends ConsumerStatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  ConsumerState<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends ConsumerState<CalculadoraScreen> {
  final _scrollController = ScrollController();
  int _cantidadAnterior = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollAlFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    // Si se agregó un producto nuevo, desliza la lista hasta el final
    if (state.productos.length > _cantidadAnterior) {
      _scrollAlFinal();
    }
    _cantidadAnterior = state.productos.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            // Navegar al historial (lo conectamos en el paso 7)
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
              controller: _scrollController,
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

          // Fila de AC + display + AC
          Row(
            children: [
              _BotonLateral(
                texto: 'AC',
                color: Colors.red,
                onTap: notifier.limpiarTodo,
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

          // Fila de flechas/teclado/flechas
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
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onTap,
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            softWrap: false,
            overflow: TextOverflow.visible,
          ),
        ),
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

  ButtonStyle _estilo(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                style: _estilo(Colors.orange),
                onPressed: onLimpiar,
                child: const Center(
                  child: Text(
                    'C',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                style: _estilo(Colors.blue),
                onPressed: onBackspace,
                child: const Center(
                  child: Icon(Icons.chevron_left, color: Colors.white, size: 26),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                style: _estilo(Colors.blue),
                onPressed: onAgregar,
                child: const Center(
                  child: Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}