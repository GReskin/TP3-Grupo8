import 'package:flutter/material.dart';
import 'package:app_gastos_tp3_grupo8/screens/anadirGasto.dart';
import 'package:app_gastos_tp3_grupo8/screens/crearGastoGrupo.dart';

class AnadirGastoGeneral extends StatelessWidget {
  const AnadirGastoGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Añadir Gastos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Gasto Personal', icon: Icon(Icons.person)),
            Tab(text: 'Gasto Grupal', icon: Icon(Icons.group)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AnadirGasto(),         
            CrearGastoGrupo(),    
          ],
        ),
      ),
    );
  }
}
