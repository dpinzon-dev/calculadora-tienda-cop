import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:calculadora_tienda/data/models/producto.dart';
import 'package:calculadora_tienda/data/models/calculo.dart';
import 'package:calculadora_tienda/data/models/perfil_color.dart';
import 'package:calculadora_tienda/data/repositories/historial_repository.dart';

void main() {
  setUp(() async {
  await setUpTestHive();
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProductoAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CalculoAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(PerfilColorAdapter());
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('limpiarExpirados elimina cálculos de más de 7 días', () async {
  final repo = HistorialRepository();

  final viejo = Calculo(
  id: 'viejo',
  productos: [Producto(id: 'p1', valorUnitario: 1000, cantidad: 1)],
  total: 1000,
  fecha: DateTime.now().subtract(const Duration(days: 8)),
  perfil: PerfilColor.rojo,
  );

  final reciente = Calculo(
  id: 'reciente',
  productos: [Producto(id: 'p2', valorUnitario: 2000, cantidad: 1)],
  total: 2000,
  fecha: DateTime.now().subtract(const Duration(days: 2)),
  perfil: PerfilColor.azul,
  );

  await repo.guardar(viejo);
  await repo.guardar(reciente);

  await repo.limpiarExpirados();

  final restantes = await repo.listarTodos();
  expect(restantes.length, 1);
  expect(restantes.first.id, 'reciente');
  });
}