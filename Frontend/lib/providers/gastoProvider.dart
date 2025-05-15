import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gastos_tp3_grupo8/models/gasto.dart';
import 'dart:math';

class GastoProvider with ChangeNotifier {
  // Propiedades privadas
  List<Gasto> _gastos = [];
  List<dynamic> _categorias = [];
  int _idCategoriaSeleccionada = 1;
  DateTime _fecha = DateTime.now();

  String? _gastoError;
  String? _gastosError;

  bool _gastoCreado = false;
  bool _isLoadingGastos = false;

  // Getters públicos
  List<Gasto> get gastos => _gastos;
  List<dynamic> get categorias => _categorias;
  int get idCategoria => _idCategoriaSeleccionada;
  DateTime get fecha => _fecha;
  String? get gastoError => _gastoError;
  String? get gastosError => _gastosError;
  bool get gastoCreado => _gastoCreado;
  bool get isLoadingGastos => _isLoadingGastos;

  // Obtener el ID del usuario desde SharedPreferences
  Future<int?> _getIdUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idusuario');
  }

  // Cargar categorías desde la API
  Future<void> cargarCategorias() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/categorias'),
      );
      if (response.statusCode == 200) {
        _categorias = jsonDecode(response.body);
      } else {
        _categorias = [];
        debugPrint("Error al cargar categorías: ${response.statusCode}");
      }
    } catch (e) {
      _categorias = [];
      debugPrint("Excepción al cargar categorías: $e");
    }
    notifyListeners();
  }

  // Crear un nuevo gasto
  Future<void> crearGasto(String descripcion, String montoTexto) async {
    final idusuario = await _getIdUsuario();
    if (idusuario == null) {
      _setGastoError("Usuario no logueado.");
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
      } else {
        _setGastoError("Error al crear el gasto: ${response.body}");
      }
    } catch (e) {
      _setGastoError("Error de conexión al crear el gasto: $e");
    }
    notifyListeners();
  }

  // Cargar los gastos del usuario
  Future<void> fetchGastos() async {
    _isLoadingGastos = true;
    _gastosError = null;
    notifyListeners();

    final idusuario = await _getIdUsuario();
    if (idusuario == null) {
      _setGastosError("ID de usuario no encontrado.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/gastos/usuarios/$idusuario'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        _gastos = data.map((json) => Gasto.fromJson(json)).toList();
      } else {
        _setGastosError("Error al cargar los gastos: ${response.body}");
      }
    } catch (e) {
      _setGastosError("Error de conexión al cargar los gastos: $e");
    }

    _isLoadingGastos = false;
    notifyListeners();
  }

  // Métodos para UI
  void actualizarFecha(DateTime nuevaFecha) {
    _fecha = nuevaFecha;
    notifyListeners();
  }

  void seleccionarCategoria(int id) {
    _idCategoriaSeleccionada = id;
    notifyListeners();
  }

  void resetGastoState() {
    _gastoCreado = false;
    _gastoError = null;
    notifyListeners();
  }

  // Métodos auxiliares de error
  void _setGastoError(String message) {
    _gastoError = message;
    _gastoCreado = false;
  }

  void _setGastosError(String message) {
    _gastosError = message;
    _isLoadingGastos = false;
    notifyListeners();
  }

  // Obtener nombre de categoría por ID
  String getCategoriaName(int id) {
    final categoria = _categorias.firstWhere(
      (cat) => cat['id'] == id,
      orElse: () => {'nombre': 'Desconocido'},
    );
    return categoria['nombre'] ?? 'Desconocido';
  }

  // Devolver un color asociado a una categoría

  Color colorForCategory(String category) {
    final hash = category.hashCode;
    final random = Random(hash);

    return Color.fromARGB(
      255,
      100 + random.nextInt(156), // avoid too dark colors
      100 + random.nextInt(156),
      100 + random.nextInt(156),
    );
  }
}
