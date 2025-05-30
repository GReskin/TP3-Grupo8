import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/grupoProvider.dart';

class VerGastosGrupales extends StatefulWidget {
  final int idGrupo;
  const VerGastosGrupales({Key? key, required this.idGrupo}) : super(key: key);

  @override
  State<VerGastosGrupales> createState() => _VerGastosGrupalesState();
}

class _VerGastosGrupalesState extends State<VerGastosGrupales> {
  bool isLoading = true;
  String? error;
  List<dynamic> gastos = [];

  @override
  void initState() {
    super.initState();
    cargarGastos();
  }

  Future<void> cargarGastos() async {
    try {
      final grupoProvider = Provider.of<GrupoProvider>(context, listen: false);
      final resultado = await grupoProvider.fetchGastosPorGrupo(widget.idGrupo);

      setState(() {
        gastos = resultado;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $error')),
      );
    }

    if (gastos.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No hay gastos para este grupo')),
      );
    }

    final total = gastos.fold<double>(
  0.0,
  (sum, g) => sum + (double.tryParse(g['monto'].toString()) ?? 0.0),
);


    return Scaffold(
      appBar: AppBar(title: const Text('Gastos del Grupo')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sections: gastos.map((g) {
  final monto = double.tryParse(g['monto'].toString()) ?? 0.0;
  final porcentaje = total > 0 ? (monto / total * 100) : 0.0;

  return PieChartSectionData(
    value: monto,
    title: '${porcentaje.toStringAsFixed(1)}%',
    color: _colorForIndex(gastos.indexOf(g)),
    radius: 80,
    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
  );
}).toList(),

              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final gasto = gastos[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _colorForIndex(index),
                  ),
                  title: Text(gasto['descripcion'] ?? 'Sin descripción'),
                  subtitle: Text('Monto: \$${gasto['monto']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper para asignar colores distintos a cada sección
  Color _colorForIndex(int index) {
    const colores = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
    ];
    return colores[index % colores.length];
  }
}
