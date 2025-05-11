import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_routes.dart'; // Asegúrate de tener este archivo importado
import 'package:app_gastos_tp3_grupo8/providers/gastoProvider.dart'; // Tu provider

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => GastoProvider())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter, // Aquí usamos tu enrutador GoRouter
    );
  }
}
