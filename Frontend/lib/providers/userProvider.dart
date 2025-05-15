// user_provider.dart
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuarioService.dart';
import 'package:go_router/go_router.dart';

class UserProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _registrationError;
  bool _registrationSuccess = false;

  bool get isLoading => _isLoading;
  String? get registrationError => _registrationError;
  bool get registrationSuccess => _registrationSuccess;

  Future<bool> registerUser(Usuario usuario, BuildContext context) async {
    _isLoading = true;
    _registrationError = null;
    _registrationSuccess = false;
    notifyListeners();

    final created = await UsuarioService.crearUsuario(usuario);

    _isLoading = false;
    if (created) {
      _registrationSuccess = true;
      notifyListeners();
      return true;
    } else {
      _registrationError = 'Error al registrar usuario';
      notifyListeners();
      return false;
    }
  }

  void resetRegistrationState() {
    _registrationSuccess = false;
    _registrationError = null;
    notifyListeners();
  }
}
