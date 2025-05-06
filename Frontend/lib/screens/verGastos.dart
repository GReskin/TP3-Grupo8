import 'package:app_gastos_tp3_grupo8/entities/gasto.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Gastos extends StatefulWidget {
   Gastos({super.key});

  @override
  State<Gastos> createState() => _GastosState();
}

class _GastosState extends State<Gastos> {
  List<Gasto> gastos = gastosLista;

  @override
  Widget build(BuildContext context) {
    final Map<String, double> gastosPorCategoria = {};

    for (var gasto in gastosLista) {
      gastosPorCategoria[gasto.categoria] = (gastosPorCategoria[gasto.categoria] ?? 0) + gasto.monto;
    }

    final List<PieChartSectionData> pieSections = gastosPorCategoria.entries.map((entry) {
      final color = _colorForCategory(entry.key);
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: entry.key,
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gastos"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Distribución de gastos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: pieSections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Lista de gastos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: gastosLista.length,
                itemBuilder: (context, index) {
                  final gasto = gastosLista[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(Icons.attach_money, color: _colorForCategory(gasto.categoria)),
                      title: Text(gasto.descripcion),
                      subtitle: Text("${gasto.categoria} - ${gasto.fecha}"),
                      trailing: Text("\$${gasto.monto.toStringAsFixed(2)}"),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _colorForCategory(String category) {
    switch (category) {
      case "Supermercado":
        return Colors.green;
      case "Ropa":
        return Colors.blue;
      case "Juegos":
        return Colors.purple;
      case "Transporte":
        return Colors.orange;
      case "Ocio":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
