class Gasto {
  final double monto;
  final String descripcion;
  final String fecha;
  final int idcategoria;
  final int idusuario;

  Gasto({
    required this.monto,
    required this.descripcion,
    required this.fecha,
    required this.idcategoria,
    required this.idusuario,
  });

  // Convertir a un Map
  Map<String, dynamic> toJson() => {
        'monto': monto,
        'descripcion': descripcion,
        'fecha': fecha,
        'idcategoria': idcategoria,
        'idusuario': idusuario,
      };

  // Convertir desde un Map
  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      idusuario: json['idusuario'],
      descripcion: json['descripcion'],
      // Convertir el monto a double
      monto: (json['monto'] is String) ? double.tryParse(json['monto']) ?? 0.0 : json['monto'].toDouble(),
      // Asumiendo que "categoria" es el id de la categoría
      idcategoria: json['idcategoria'],
      fecha: json['fecha'],
    );
  }
}
