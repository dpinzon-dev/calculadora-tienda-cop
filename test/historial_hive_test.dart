import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:calculadora_tienda/data/models/producto.dart';
import 'package:calculadora_tienda/data/models/calculo.dart';
import 'package:calculadora_tienda/data/models/perfil_color.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    Hive.registerAdapter(ProductoAdapter());
    Hive.registerAdapter(CalculoAdapter());
    Hive.registerAdapter(PerfilColorAdapter());
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('guarda y lee un Calculo del historial', () async {
  final box = await Hive.openBox<Calculo>('historial');

  final producto = Producto(id: 'p1', valorUnitario: 6500, cantidad: 1);
  final calculo = Calculo(
  id: 'c1',
  productos: [producto],
  total: producto.total,
  fecha: DateTime.now(),
  perfil: PerfilColor.rojo,
  );

  await box.put(calculo.id, calculo);

  final leido = box.get('c1');
  expect(leido, isNotNull);
  expect(leido!.total, 6500);
  expect(leido.perfil, PerfilColor.rojo);
  });
}