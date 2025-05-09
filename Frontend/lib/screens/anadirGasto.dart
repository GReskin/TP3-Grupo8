import 'dart:convert';
import 'package:app_gastos_tp3_grupo8/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnadirGasto extends StatefulWidget {
  @override
  _AnadirGastoState createState() => _AnadirGastoState();
}

class _AnadirGastoState extends State<AnadirGasto> {
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  DateTime _fecha = DateTime.now();
  int _idcategoria = 1;
  List<dynamic> _categorias = [];

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

  Future<int?> _getIdUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idusuario');
  }

  // Función para crear el gasto
  Future<void> _crearGasto() async {
    final idusuario = await _getIdUsuario();
    if (idusuario == null) {
      print("Usuario no logueado.");
      return;
    }
    final gastoData = {
      'descripcion': _descripcionController.text,
      'monto': double.tryParse(_montoController.text) ?? 0.0,
      'fecha': _fecha.toIso8601String().substring(0, 10),
      'idcategoria': _idcategoria,
      'idusuario': idusuario,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/gastos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(gastoData),
    );

    if (response.statusCode == 201) {
      print("Gasto creado exitosamente");
      appRouter.push('/home');
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
        title: Text('Añadir Gasto'),
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

            DropdownButtonFormField<int>(
              value: _idcategoria,
              onChanged: (int? newValue) {
                setState(() {
                  _idcategoria = newValue!;
                });
              },
              items:
                  _categorias.map<DropdownMenuItem<int>>((categoria) {
                    return DropdownMenuItem<int>(
                      value: categoria['id'],
                      child: Text(categoria['nombre']),
                    );
                  }).toList(),
            ),

            SizedBox(height: 16.0),
            // Selector de fecha
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
            ElevatedButton(
              onPressed: _crearGasto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Crear Gasto', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
