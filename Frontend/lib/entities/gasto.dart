class Gasto {
  final String descripcion;
  final double monto;
  final String fecha;
  final String categoria;

  Gasto({
    required this.descripcion,
    required this.monto,
    required this.fecha,
    required this.categoria,
  });
}

List<Gasto> gastosLista = [
  Gasto(
    descripcion: "Compras en supermercado",
    monto: 8500.50,
    fecha: "02/05/2025",
    categoria: "Supermercado",
  ),
  Gasto(
    descripcion: "Campera nueva",
    monto: 12500.00,
    fecha: "30/04/2025",
    categoria: "Ropa",
  ),
  Gasto(
    descripcion: "Suscripción a videojuego",
    monto: 1800.00,
    fecha: "25/04/2025",
    categoria: "Juegos",
  ),
  Gasto(
    descripcion: "Pasaje de colectivo",
    monto: 250.00,
    fecha: "01/05/2025",
    categoria: "Transporte",
  ),
  Gasto(
    descripcion: "Cine con amigos",
    monto: 3200.00,
    fecha: "28/04/2025",
    categoria: "Ocio",
  ),
];
