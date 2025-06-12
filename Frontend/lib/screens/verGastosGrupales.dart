import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/grupoProvider.dart';
import '../providers/gastoProvider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cargarDatos();
    });
  }

  Future<void> cargarDatos() async {
    try {
      final grupoProvider = Provider.of<GrupoProvider>(context, listen: false);
      final gastoProvider = Provider.of<GastoProvider>(context, listen: false);

      await gastoProvider.cargarCategorias(); // ⚠ ahora sí cargamos categorías

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
    final gastoProvider = Provider.of<GastoProvider>(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text('Error: $error')));
    }

    if (gastos.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No hay gastos para este grupo')),
      );
    }

    final Map<String, double> gastosPorCategoria = {};
    for (var gasto in gastos) {
      final categoria = gastoProvider.getCategoriaName(gasto['idcategoria']);
      gastosPorCategoria[categoria] =
          (gastosPorCategoria[categoria] ?? 0) +
          (double.tryParse(gasto['monto'].toString()) ?? 0.0);
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

    return Scaffold(
      appBar: AppBar(title: const Text('Gastos del Grupo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                  final categoria = gastoProvider.getCategoriaName(
                    gasto['idcategoria'],
                  );
                  final color = gastoProvider.colorForCategory(categoria);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(Icons.attach_money, color: color),
                      title: Text(gasto['descripcion'] ?? 'Sin descripción'),
                      subtitle: Text('$categoria - ${gasto['fecha'] ?? ''}'),
                      trailing: Text(
                        '\$${(double.tryParse(gasto['monto'].toString()) ?? 0.0).toStringAsFixed(2)}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
