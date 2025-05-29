import 'package:flutter/material.dart';

class Menu {
  String title;
  String subtitle;
  String description;
  String path;
  Icon icon;

  Menu({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.path,
  });
}

List<Menu> menuList = [
  Menu(
    title: "Ver Gastos",
    subtitle: "Ver tus gastos personales y grupales",
    description: "Consulta todos tus gastos desde una misma vista",
    icon: Icon(Icons.money_off),
    path: "/verGastosGeneral", // 👉 Nueva ruta
  ),

  Menu(
    title: "Crear Grupo De Ahorro",
    subtitle: "Crea tu grupo de ahorro",
    description: "sdalksdkajshdkjlasdhlsakjdka",
    icon: Icon(Icons.group),
    path: "/crearGrupo",
  ),

  Menu(
    title: 'Añadir Gastos',
    subtitle: 'Individual y grupal con pestañas',
    icon: Icon(Icons.add_chart),
    path: '/gastosGenerales',
    description:
        'Añadir un gasto tanto grupal como individual', // usa la ruta nueva
  ),
];
