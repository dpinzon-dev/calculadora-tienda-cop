import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/formato_cop.dart';
import '../../../data/models/color_resaltado.dart';
import '../../../data/models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onIncrementar;
  final VoidCallback onDecrementar;
  final VoidCallback onEliminar;
  final void Function(ColorResaltado color) onCambiarResaltado;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onIncrementar,
    required this.onDecrementar,
    required this.onEliminar,
    required this.onCambiarResaltado,
  });

  Future<void> _confirmarEliminar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: const Text(
          '¿Seguro que quieres eliminar este producto del cálculo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white, // Color del texto
            ),
            child: Text('Eliminar', style: TextStyle(color: AppColors.surface)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      onEliminar();
    }
  }

  Color get _colorFondo {
    switch (producto.resaltado) {
      case ColorResaltado.ninguno:
        return AppColors.cardNeutral;
      case ColorResaltado.amarillo:
        return const Color(0xFFFFF3C4);
      case ColorResaltado.morado:
        return const Color(0xFFE6D7F5);
      case ColorResaltado.naranja:
        return const Color(0xFFFFE0CC);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _colorFondo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Botón eliminar
          IconButton(
            icon: Icon(Icons.delete, color: AppColors.danger),
            onPressed: () => _confirmarEliminar(context),
          ),

          // Grupo precio + multiplicador (sin expansión)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Columna con precio y valor unitario
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatearCOP(producto.total),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (producto.cantidad > 1)
                    Text(
                      formatearCOP(producto.valorUnitario),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              // separación entre precio y multiplicador
              // Multiplicador (al lado del precio)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textPrimary),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('x${producto.cantidad}',style: const TextStyle(color: AppColors.textPrimary),),
              ),
            ],
          ),

          // Espacio flexible para separar el grupo de las banderitas
          const Spacer(),

          // Banderitas de resaltado
          Row(
            children: [
              _BanderaResaltado(
                color: Colors.amber,
                activa: producto.resaltado == ColorResaltado.amarillo,
                onTap: () => onCambiarResaltado(ColorResaltado.amarillo),
              ),
              const SizedBox(width: 6),
              _BanderaResaltado(
                color: Colors.purple,
                activa: producto.resaltado == ColorResaltado.morado,
                onTap: () => onCambiarResaltado(ColorResaltado.morado),
              ),
              const SizedBox(width: 6),
              _BanderaResaltado(
                color: Colors.deepOrange,
                activa: producto.resaltado == ColorResaltado.naranja,
                onTap: () => onCambiarResaltado(ColorResaltado.naranja),
              ),
            ],
          ),

          const SizedBox(width: 8),
          _CircleButton(
            icon: Icons.remove,
            color: AppColors.danger,
            onTap: onDecrementar,
          ),
          const SizedBox(width: 6),
          _CircleButton(
            icon: Icons.add,
            color: AppColors.success,
            onTap: onIncrementar,
          ),
        ],
      ),
    );
  }
}

class _BanderaResaltado extends StatelessWidget {
  final Color color;
  final bool activa;
  final VoidCallback onTap;

  const _BanderaResaltado({
    required this.color,
    required this.activa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 24,
        height: 24,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Bandera negra de fondo, un poco más grande: simula un borde cuando está activa
            if (activa) const Icon(Icons.flag, size: 24, color: Colors.black),
            Icon(Icons.flag, size: activa ? 19 : 22, color: color),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

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