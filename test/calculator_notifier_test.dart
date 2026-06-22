import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculadora_tienda/features/calculadora/providers/calculator_notifier.dart';

void main() {
  test('agrega producto, incrementa, decrementa y no baja de 1', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(calculatorProvider.notifier);

    // Teclear 6500 y agregar producto
    notifier.teclear('6');
    notifier.teclear('5');
    notifier.teclear('0');
    notifier.teclear('0');
    notifier.agregarProducto();

    var state = container.read(calculatorProvider);
    expect(state.productos.length, 1);
    expect(state.productos.first.cantidad, 1);
    expect(state.total, 6500);
    expect(state.displayActual, '0'); // el display se reinicia

    final id = state.productos.first.id;

    // Incrementar dos veces -> cantidad 3
    notifier.incrementarCantidad(id);
    notifier.incrementarCantidad(id);
    state = container.read(calculatorProvider);
    expect(state.productos.first.cantidad, 3);
    expect(state.total, 19500);

    // Decrementar hasta el límite
    notifier.decrementarCantidad(id);
    notifier.decrementarCantidad(id);
    notifier.decrementarCantidad(id); // ya está en 1, no debe bajar más
    state = container.read(calculatorProvider);
    expect(state.productos.first.cantidad, 1);

    // Eliminar producto
    notifier.eliminarProducto(id);
    state = container.read(calculatorProvider);
    expect(state.productos.isEmpty, true);
  });

  test('AC limpia todo, C solo limpia el display', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(calculatorProvider.notifier);

    notifier.teclear('1');
    notifier.teclear('0');
    notifier.agregarProducto();
    notifier.teclear('5'); // empieza a teclear otro valor sin confirmar

    notifier.limpiarDisplay(); // C
    var state = container.read(calculatorProvider);
    expect(state.displayActual, '0');
    expect(state.productos.length, 1); // el producto ya agregado no se borra

    notifier.limpiarTodo(); // AC
    state = container.read(calculatorProvider);
    expect(state.productos.isEmpty, true);
    expect(state.displayActual, '0');
  });
}