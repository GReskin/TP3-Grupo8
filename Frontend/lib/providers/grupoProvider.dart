import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GrupoProvider with ChangeNotifier {
  List<dynamic> categorias = [];
  List<dynamic> grupos = [];

  Future<void> fetchGrupos() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/grupos'), //emulador android
    );

    if (response.statusCode == 200) {
      grupos = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      notifyListeners();
    } else {
      throw Exception("Error al cargar grupos");
    }
  }

  Future<int?> obtenerCreadorId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idusuario');
  }

  final TextEditingController nombreGrupoController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();

  List<Map<String, dynamic>> usuariosDisponibles = [];
  List<Map<String, dynamic>> usuariosGrupo = [];

  Future<void> fetchUsuarios() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/usuarios'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          usuariosDisponibles = List<Map<String, dynamic>>.from(data);
        } else {
          usuariosDisponibles = [];
          debugPrint('Formato inesperado en respuesta de usuarios');
        }
      } else {
        usuariosDisponibles = [];
        debugPrint("Error al cargar usuarios: ${response.statusCode}");
      }
    } catch (e) {
      usuariosDisponibles = [];
      debugPrint("Excepción al cargar usuarios: $e");
    }
    notifyListeners();
  }

  Future<void> fetchCategorias() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/categorias'),
    );

    if (response.statusCode == 200) {
      categorias = jsonDecode(response.body);
      notifyListeners();
    } else {
      throw Exception("Error al cargar categorías");
    }
  }

  Future<bool> crearGastoGrupo({
    required String descripcion,
    required double monto,
    required DateTime fecha,
    required int idcategoria,
    required int idgrupo,
  }) async {
    final gastoData = {
      'descripcion': descripcion,
      'monto': monto,
      'fecha': fecha.toIso8601String().substring(0, 10),
      'idcategoria': idcategoria,
      'idgrupo': idgrupo,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/gastos-grupo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(gastoData),
    );

    return response.statusCode == 201;
  }

  //Manejo de creacion y administracion de usuarios y grupos

  void agregarUsuario(BuildContext context, Map<String, dynamic> usuario) {
    final nombreUsuario = usuario['usuario'];

    if (usuariosGrupo.any((u) => u['id'] == usuario['id'])) {
      _mostrarSnackBar(
        context,
        'El usuario "$nombreUsuario" ya está en el grupo',
      );
      return;
    }

    usuariosGrupo.add(usuario);
    usuarioController.clear();
    notifyListeners();
  }

  void eliminarUsuario(String usuario) {
    usuariosGrupo.remove(usuario);
    notifyListeners();
  }

  void eliminarUsuarioPorId(int idUsuario) {
  usuariosGrupo.removeWhere((u) => u['id'] == idUsuario);
  notifyListeners();
}


  Future<void> crearGrupo(BuildContext context) async {
    final nombreGrupo = nombreGrupoController.text.trim();
    final creadorId = await obtenerCreadorId();

    if (nombreGrupo.isEmpty || usuariosGrupo.isEmpty) {
      _mostrarSnackBar(
        context,
        'Completa el nombre del grupo y agrega al menos un usuario',
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/grupos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombreGrupo,
          'usuarios': usuariosGrupo.map((u) => u['id']).toList(),
          'creador_id': creadorId,
        }),
      );

      if (response.statusCode == 201) {
        _mostrarSnackBar(context, 'Grupo "$nombreGrupo" creado con éxito');
        nombreGrupoController.clear();
        usuarioController.clear();
        usuariosGrupo.clear();
        notifyListeners();
      } else {
        _mostrarSnackBar(context, 'Error al crear el grupo');
        print('Error: ${response.body}');
      }
    } catch (e) {
      _mostrarSnackBar(context, 'Error al conectar con el servidor');
      print('Exception: $e');
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }
}
