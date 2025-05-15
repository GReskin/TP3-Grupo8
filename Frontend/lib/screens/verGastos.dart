import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/gastoProvider.dart';

class Gastos extends StatefulWidget {
  const Gastos({super.key});

  @override
  State<Gastos> createState() => _GastosState();
}

class _GastosState extends State<Gastos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gastoProvider = Provider.of<GastoProvider>(context, listen: false);
      gastoProvider.cargarCategorias(); // 👈 Necesario para mapear los nombres
      gastoProvider.fetchGastos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gastos"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<GastoProvider>(context, listen: false).fetchGastos();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<GastoProvider>(
          builder: (context, gastoProvider, _) {
            if (gastoProvider.isLoadingGastos) {
              return const Center(child: CircularProgressIndicator());
            }

            if (gastoProvider.gastosError != null) {
              return Center(
                child: Text("Error: ${gastoProvider.gastosError!}"),
              );
            }

            final gastos = gastoProvider.gastos;

            if (gastos.isEmpty) {
              return const Center(child: Text("No hay gastos cargados"));
            }

            final Map<String, double> gastosPorCategoria = {};
            for (var gasto in gastos) {
              String categoria = gastoProvider.getCategoriaName(
                gasto.idcategoria,
              );
              gastosPorCategoria[categoria] =
                  (gastosPorCategoria[categoria] ?? 0) + gasto.monto;
            }

            final List<PieChartSectionData> pieSections =
                gastosPorCategoria.entries.map((entry) {
                  final color = gastoProvider.colorForCategory(entry.key);
                  return PieChartSectionData(
                    color: color,
                    value: entry.value,
                    title: entry.key,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  );
                }).toList();

            return Column(
              children: [
                const Text(
                  "Distribución de gastos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
                const Text(
                  "Lista de gastos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: gastos.length,
                    itemBuilder: (context, index) {
                      final gasto = gastos[index];
                      String categoria = gastoProvider.getCategoriaName(
                        gasto.idcategoria,
                      );
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(
                            Icons.attach_money,
                            color: gastoProvider.colorForCategory(categoria),
                          ),
                          title: Text(gasto.descripcion),
                          subtitle: Text("$categoria - ${gasto.fecha}"),
                          trailing: Text("\$${gasto.monto.toStringAsFixed(2)}"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
