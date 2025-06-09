import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class GrupoProvider with ChangeNotifier {
  List<dynamic> categorias = [];
  List<dynamic> grupos = [];

  /*
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
*/
  Future<void> fetchGrupos(int usuarioId) async {
    final url = Uri.parse(
      'http://10.0.2.2:3000/api/usuarios/$usuarioId/grupos',
    );

    try {
      final response = await http.get(url);
      print("📥 Status code: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        grupos = List<Map<String, dynamic>>.from(json.decode(response.body));
        notifyListeners();
      } else {
        throw Exception("Error al obtener los grupos del usuario");
      }
    } catch (e) {
      print("❌ Excepción en fetchGrupos: $e");
      rethrow;
    }
  }

  List<dynamic> gastosGrupo = [];
  bool isLoadingGastosGrupo = false;
  String? errorGastosGrupo;

  Future<List<dynamic>> fetchGastosPorGrupo(int idGrupo) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/gastos_grupo/$idGrupo');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        gastosGrupo = jsonDecode(response.body);
        notifyListeners();
        return gastosGrupo; // Retorna la lista para que quien llame la use
      } else {
        errorGastosGrupo = 'Error: ${response.statusCode}';
        gastosGrupo = [];
        notifyListeners();
        return [];
      }
    } catch (e) {
      errorGastosGrupo = 'Excepción: $e';
      gastosGrupo = [];
      notifyListeners();
      return [];
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
    final url = Uri.parse('http://10.0.2.2:3000/api/gastos_grupo/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'descripcion': descripcion,
        'monto': monto,
        'fecha': fecha.toIso8601String(),
        'idcategoria': idcategoria,
        'idgrupo': idgrupo,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Error al crear gasto grupo: ${response.body}');
      return false;
    }
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

  void _mostrarSnackBar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> crearGrupo(BuildContext context) async {
    final nombreGrupo = nombreGrupoController.text.trim();
    final creadorId = await obtenerCreadorId();
    final usuariosIds = usuariosGrupo.map((u) => u['id']).toList();

    if (nombreGrupo.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Debe ingresar nombre del grupo')));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/grupos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombreGrupo,
          'creador_id': creadorId,
          'usuarios': usuariosIds,
        }),
      );

      if (response.statusCode == 201) {
        // Aquí va el bloque que mencionaste
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Grupo creado con éxito')));
        await fetchGrupos(creadorId!); // <--- Esta línea aquí
        nombreGrupoController.clear();
        usuariosGrupo.clear();
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error['error'] ?? 'Desconocido'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de conexión')));
    }
  }

  String getCategoriaName(int id) {
    final categoria = categorias.firstWhere(
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
