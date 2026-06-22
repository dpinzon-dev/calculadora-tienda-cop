import 'package:flutter/material.dart';

class TecladoNumerico extends StatelessWidget {
  final void Function(String digito) onDigito;
  final VoidCallback onBackspace;
  final VoidCallback onAgregar;

  const TecladoNumerico({
    super.key,
    required this.onDigito,
    required this.onBackspace,
    required this.onAgregar,
  });

  static const _filas = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    ['0', '00', '000'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _filas.map((fila) {
        return Row(
          children: fila.map((digito) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () => onDigito(digito),
                  child: Center(
                    child: Text(digito, style: const TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
