import 'dart:convert';
import 'package:app_gastos_tp3_grupo8/models/gasto.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Gastos extends StatefulWidget {
  const Gastos({super.key});

  @override
  State<Gastos> createState() => _GastosState();
}

class _GastosState extends State<Gastos> {
  List<Gasto> gastos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGastos();
  }

  Future<void> _fetchGastos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('idusuario');

      

      if (userId == null) {
        print("ID de usuario no encontrado.");
        return;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/gastos/usuarios/$userId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          gastos = data.map((gastoJson) => Gasto.fromJson(gastoJson)).toList();
          isLoading = false;
        });
      } else {
        print("Error al cargar los gastos: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error de conexión: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, double> gastosPorCategoria = {};
    for (var gasto in gastos) {
      String categoria = _getCategoriaName(gasto.idcategoria);
      gastosPorCategoria[categoria] =
          (gastosPorCategoria[categoria] ?? 0) + gasto.monto;
    }

    final List<PieChartSectionData> pieSections =
        gastosPorCategoria.entries.map((entry) {
      final color = _colorForCategory(entry.key);
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
      appBar: AppBar(
        title: const Text("Gastos"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _fetchGastos),
        ],
      ),
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
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : gastos.isEmpty
                      ? Center(child: Text("No hay gastos cargados"))
                      : PieChart(
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
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : gastos.isEmpty
                      ? Center(child: Text("No hay gastos cargados"))
                      : ListView.builder(
                          itemCount: gastos.length,
                          itemBuilder: (context, index) {
                            final gasto = gastos[index];
                            String categoria =
                                _getCategoriaName(gasto.idcategoria);
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: Icon(
                                  Icons.attach_money,
                                  color: _colorForCategory(categoria),
                                ),
                                title: Text(gasto.descripcion),
                                subtitle:
                                    Text("$categoria - ${gasto.fecha}"),
                                trailing: Text(
                                    "\$${gasto.monto.toStringAsFixed(2)}"),
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

  final Map<int, String> categoriasMap = {
    1: 'Alimentos',
    2: 'Transporte',
    3: 'Entretenimiento',
    4: 'Salud',
    5: 'Educacion',
  };

  String _getCategoriaName(int id) {
    return categoriasMap[id] ?? 'Desconocido';
  }

  Color _colorForCategory(String category) {
    switch (category) {
      case "Alimentos":
        return Colors.green;
      case "Transporte":
        return Colors.blue;
      case "Entretenimiento":
        return Colors.purple;
      case "Salud":
        return Colors.orange;
      case "Educacion":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
