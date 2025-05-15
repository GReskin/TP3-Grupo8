import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_routes.dart';
import 'package:app_gastos_tp3_grupo8/providers/gastoProvider.dart';
import 'package:app_gastos_tp3_grupo8/providers/userProvider.dart'; // Import UserProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GastoProvider()),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ), // Add UserProvider
      ],
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
      routerConfig: appRouter,
    );
  }
}
