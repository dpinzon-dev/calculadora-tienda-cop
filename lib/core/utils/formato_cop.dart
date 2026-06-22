import 'package:intl/intl.dart';

final _formatoCOP = NumberFormat.decimalPattern('es_CO');

String formatearCOP(double valor) {
  return _formatoCOP.format(valor);
}