import 'package:flutter/material.dart';
import 'package:app_gastos_tp3_grupo8/screens/verGastos.dart';

class VerGastosGeneral extends StatelessWidget {
  const VerGastosGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ver Gastos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Gasto Personal', icon: Icon(Icons.person)),
              Tab(text: 'Gasto Grupal', icon: Icon(Icons.group)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Gastos(),
            Center(
              child: Text(
                'La funcionalidad de Gasto Grupal estará disponible en el futuro.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
