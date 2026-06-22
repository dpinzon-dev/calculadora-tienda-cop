import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:calculadora_tienda/features/calculadora/providers/calculator_notifier.dart';
import 'package:calculadora_tienda/features/calculadora/providers/calculator_state.dart';
import 'package:calculadora_tienda/data/models/producto.dart';
import 'package:calculadora_tienda/data/models/calculo.dart';
import 'package:calculadora_tienda/data/models/perfil_color.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductoAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CalculoAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(PerfilColorAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CalculatorStateAdapter());
    }
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  const perfil = PerfilColor.rojo;

  test('agrega producto, incrementa, decrementa y no baja de 1', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(calculatorProvider(perfil).notifier);

    // Teclear 6500 y agregar producto
    notifier.teclear('6');
    notifier.teclear('5');
    notifier.teclear('0');
    notifier.teclear('0');
    notifier.agregarProducto();

    var state = container.read(calculatorProvider(perfil));
    expect(state.productos.length, 1);
    expect(state.productos.first.cantidad, 1);
    expect(state.total, 6500);
    expect(state.displayActual, '0'); // el display se reinicia

    final id = state.productos.first.id;

    // Incrementar dos veces -> cantidad 3
    notifier.incrementarCantidad(id);
    notifier.incrementarCantidad(id);
    state = container.read(calculatorProvider(perfil));
    expect(state.productos.first.cantidad, 3);
    expect(state.total, 19500);

    // Decrementar hasta el límite
    notifier.decrementarCantidad(id);
    notifier.decrementarCantidad(id);
    notifier.decrementarCantidad(id); // ya está en 1, no debe bajar más
    state = container.read(calculatorProvider(perfil));
    expect(state.productos.first.cantidad, 1);

    // Eliminar producto
    notifier.eliminarProducto(id);
    state = container.read(calculatorProvider(perfil));
    expect(state.productos.isEmpty, true);
  });

  test('AC limpia todo, C solo limpia el display', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(calculatorProvider(perfil).notifier);

    notifier.teclear('1');
    notifier.teclear('0');
    notifier.agregarProducto();
    notifier.teclear('5'); // empieza a teclear otro valor sin confirmar

    notifier.limpiarDisplay(); // C
    var state = container.read(calculatorProvider(perfil));
    expect(state.displayActual, '0');
    expect(state.productos.length, 1); // el producto ya agregado no se borra

    notifier.limpiarTodo(); // AC
    state = container.read(calculatorProvider(perfil));
    expect(state.productos.isEmpty, true);
    expect(state.displayActual, '0');
  });

  test('cada perfil mantiene su propio estado independiente', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final rojoNotifier = container.read(calculatorProvider(PerfilColor.rojo).notifier);
    final azulNotifier = container.read(calculatorProvider(PerfilColor.azul).notifier);

    rojoNotifier.teclear('1');
    rojoNotifier.teclear('0');
    rojoNotifier.teclear('0');
    rojoNotifier.teclear('0');
    rojoNotifier.agregarProducto();

    azulNotifier.teclear('5');
    azulNotifier.teclear('0');
    azulNotifier.teclear('0');
    azulNotifier.agregarProducto();

    final estadoRojo = container.read(calculatorProvider(PerfilColor.rojo));
    final estadoAzul = container.read(calculatorProvider(PerfilColor.azul));

    expect(estadoRojo.total, 1000);
    expect(estadoAzul.total, 500);
  });
}