class Usuario {
  final String usuario;
  final String email;
  final String fechaNacimiento;
  final String password;

  Usuario({
    required this.usuario,
    required this.email,
    required this.fechaNacimiento,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'usuario': usuario,
        'email': email,
        'fecha_nacimiento': fechaNacimiento,
        'contraseña': password,
      };
}