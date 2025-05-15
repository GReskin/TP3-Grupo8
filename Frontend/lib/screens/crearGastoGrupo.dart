import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrearGastoGrupo extends StatefulWidget {
  @override
  _CrearGastoGrupoState createState() => _CrearGastoGrupoState();
}

class _CrearGastoGrupoState extends State<CrearGastoGrupo> {
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  DateTime _fecha = DateTime.now();

  int _idcategoria = 1;
  int _idgrupo = 1;

  List<dynamic> _categorias = [];
  List<Map<String, dynamic>> _grupos = [
    {'id': 1, 'nombre': 'Viaje a Bariloche'},
    {'id': 2, 'nombre': 'Cumpleaños de Ana'},
    {'id': 3, 'nombre': 'Proyecto Universidad'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
  }

  Future<void> _fetchCategorias() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/categorias'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _categorias = jsonDecode(response.body);
      });
    } else {
      print("Error al cargar categorías");
    }
  }

  Future<void> _crearGastoGrupo() async {
    final gastoData = {
      'descripcion': _descripcionController.text,
      'monto': double.tryParse(_montoController.text) ?? 0.0,
      'fecha': _fecha.toIso8601String().substring(0, 10),
      'idcategoria': _idcategoria,
      'idgrupo': _idgrupo,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/gastos-grupo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(gastoData),
    );

    if (response.statusCode == 201) {
      print("Gasto de grupo creado exitosamente");
      Navigator.pop(context);
    } else {
      print("Error al crear el gasto: ${response.body}");
    }
  }

  Future<void> _selectFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _fecha) {
      setState(() {
        _fecha = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Gasto al Grupo'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _montoController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Monto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monetization_on),
              ),
            ),
            SizedBox(height: 16.0),

            // Grupo selector
            DropdownButtonFormField<int>(
              value: _idgrupo,
              decoration: InputDecoration(
                labelText: 'Grupo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
              onChanged: (int? newValue) {
                setState(() {
                  _idgrupo = newValue!;
                });
              },
              items: _grupos.map((grupo) {
                return DropdownMenuItem<int>(
                  value: grupo['id'],
                  child: Text(grupo['nombre']),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),

            // Categoría selector
            DropdownButtonFormField<int>(
              value: _idcategoria,
              decoration: InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              onChanged: (int? newValue) {
                setState(() {
                  _idcategoria = newValue!;
                });
              },
              items: _categorias.map<DropdownMenuItem<int>>((categoria) {
                return DropdownMenuItem<int>(
                  value: categoria['id'],
                  child: Text(categoria['nombre']),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),

            // Fecha selector
            GestureDetector(
              onTap: () => _selectFecha(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  "${_fecha.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            ElevatedButton.icon(
              onPressed: _crearGastoGrupo,
              icon: Icon(Icons.add),
              label: Text('Crear Gasto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
