import 'package:flutter/material.dart';
import '../../../core/utils/formato_cop.dart';
import '../../../data/models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onIncrementar;
  final VoidCallback onDecrementar;
  final VoidCallback onEliminar;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onIncrementar,
    required this.onDecrementar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onEliminar,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatearCOP(producto.total),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                if (producto.cantidad > 1)
                  Text(
                    formatearCOP(producto.valorUnitario),
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('x${producto.cantidad}'),
          ),
          const SizedBox(width: 8),
          _CircleButton(icon: Icons.remove, color: Colors.red, onTap: onDecrementar),
          const SizedBox(width: 6),
          _CircleButton(icon: Icons.add, color: Colors.green, onTap: onIncrementar),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}