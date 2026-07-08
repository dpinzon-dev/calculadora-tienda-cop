import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/theme.dart';
import 'data/models/producto.dart';
import 'data/models/calculo.dart';
import 'data/models/perfil_color.dart';
import 'features/calculadora/calculadora_screen.dart';
import 'features/calculadora/providers/calculator_state.dart';
import 'data/repositories/historial_repository.dart';
import 'data/models/color_resaltado.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ProductoAdapter());
  Hive.registerAdapter(CalculoAdapter());
  Hive.registerAdapter(PerfilColorAdapter());
  Hive.registerAdapter(CalculatorStateAdapter());
  Hive.registerAdapter(ColorResaltadoAdapter());

  await Hive.openBox<Calculo>('historial');

  await HistorialRepository().limpiarExpirados();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Tienda',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const CalculadoraScreen(),
    );
  }
}