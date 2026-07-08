import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/formato_cop.dart';
import 'teclado_numerico.dart';

class DevolucionSheet extends StatefulWidget {
  final double totalCuenta;

  const DevolucionSheet({super.key, required this.totalCuenta});

  @override
  State<DevolucionSheet> createState() => _DevolucionSheetState();
}

class _DevolucionSheetState extends State<DevolucionSheet> {
  String _display = '0';

  void _teclear(String digito) {
    setState(() {
      _display = _display == '0' ? digito : _display + digito;
    });
  }

  void _borrar() {
    setState(() {
      if (_display.length <= 1) {
        _display = '0';
      } else {
        _display = _display.substring(0, _display.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagado = double.tryParse(_display) ?? 0;
    final vuelto = pagado - widget.totalCuenta;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Totales
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total cuenta',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    Text(
                      formatearCOP(widget.totalCuenta),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Pago con',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    Text(
                      pagado == 0 ? '—' : formatearCOP(pagado),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 24),

            // Vuelto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: vuelto >= 0
                    ? AppColors.successBackground
                    : AppColors.dangerBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Vuelto',
                    style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                  ),
                  Text(
                    pagado == 0 ? '—' : formatearCOP(vuelto.abs()),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: vuelto >= 0 ? AppColors.textPrimary : AppColors.danger,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Display del pago
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                formatearCOP(pagado),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, color: AppColors.textPrimary),
              ),
            ),

            const SizedBox(height: 8),

            // Teclado reutilizado + botón borrar a la derecha
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 8,
                    child: TecladoNumerico(
                      onDigito: _teclear,
                      onBackspace: _borrar,
                      onAgregar: _borrar, // no se usa en este contexto
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _borrar,
                        child: const Center(child: Icon(Icons.chevron_left, size: 24,)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}