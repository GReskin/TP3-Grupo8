import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gasto.dart';

class GastoService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/gastos'; // Usar 10.0.2.2 si usas emulador Android

  static Future<bool> crearGasto(Map<String, dynamic> gastoData) async {
    final prefs = await SharedPreferences.getInstance();
    final idusuario = prefs.getInt('idusuario'); // Obtener el id del usuario logueado

    if (idusuario == null) {
      print("Usuario no logueado.");
      return false; 
    }

   
    if (!gastoData.containsKey('idusuario')) {
      gastoData['idusuario'] = idusuario;
    }

    final jsonBody = jsonEncode(gastoData);
    print('Datos que se enviarán al backend: $jsonBody');

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        print("Gasto creado exitosamente");
        final data = jsonDecode(response.body);
    final idGasto = data['id'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idgasto', idGasto);  // Guardamos el ID de usuario en SharedPreferences
        return true;
      } else {
        print('Error al crear gasto: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión o servidor: $e');
      return false;
    }
  }
}
