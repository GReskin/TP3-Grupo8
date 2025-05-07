import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/usuarios'; // usar 10.0.2.2 si usás emulador Android

  static Future<bool> crearUsuario(Usuario usuario) async {
    final jsonBody = jsonEncode(usuario.toJson());
    print('Datos que se enviarán al backend: $jsonBody');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Error al crear usuario: ${response.body}');
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:3000/api/usuarios/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'contraseña': password,
    }),
  );

  if (response.statusCode == 200) {
    print('Login exitoso: ${response.body}');
    return true;
  } else {
    print('Error de login: ${response.body}');
    return false;
  }
}
}