// gastoProvider.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GastoProvider with ChangeNotifier {
  List<dynamic> _categorias = [];
  int _idCategoriaSeleccionada = 1;
  DateTime _fecha = DateTime.now();
  String? _gastoError;
  bool _gastoCreado = false;

  List<dynamic> get categorias => _categorias;
  int get idCategoria => _idCategoriaSeleccionada;
  DateTime get fecha => _fecha;
  String? get gastoError => _gastoError;
  bool get gastoCreado => _gastoCreado;

  // Reset the flags after consumption
  void resetGastoState() {
    _gastoError = null;
    _gastoCreado = false;
  }

  // Función para cargar las categorías
  Future<void> cargarCategorias() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/categorias'),
    );

    if (response.statusCode == 200) {
      _categorias = jsonDecode(response.body);
      notifyListeners();
    } else {
      print("Error al cargar categorías");
    }
  }

  // Función para obtener el id de usuario
  Future<int?> _getIdUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idusuario');
  }

  // Función para crear un gasto
  Future<void> crearGasto(String descripcion, String montoTexto) async {
    final idusuario = await _getIdUsuario();
    if (idusuario == null) {
      _gastoError = "Usuario no logueado.";
      _gastoCreado = false;
      notifyListeners();
      return;
    }

    final gastoData = {
      'descripcion': descripcion,
      'monto': double.tryParse(montoTexto) ?? 0.0,
      'fecha': _fecha.toIso8601String().substring(0, 10),
      'idcategoria': _idCategoriaSeleccionada,
      'idusuario': idusuario,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/gastos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(gastoData),
      );

      if (response.statusCode == 201) {
        _gastoCreado = true;
        _gastoError = null;
        notifyListeners();
      } else {
        _gastoError = "Error al crear el gasto: ${response.body}";
        _gastoCreado = false;
        notifyListeners();
      }
    } catch (e) {
      _gastoError = "Error de conexión al crear el gasto: $e";
      _gastoCreado = false;
      notifyListeners();
    }
  }

  // Función para actualizar la fecha
  void actualizarFecha(DateTime nuevaFecha) {
    _fecha = nuevaFecha;
    notifyListeners();
  }

  // Función para seleccionar categoría
  void seleccionarCategoria(int id) {
    _idCategoriaSeleccionada = id;
    notifyListeners();
  }
}
