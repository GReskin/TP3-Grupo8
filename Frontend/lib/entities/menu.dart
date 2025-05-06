

import 'package:flutter/material.dart';

class Menu {
  String title;
  String subtitle;
  String description;
  String path;
  Icon icon;


  Menu({required this.title,required this.subtitle,required this.description,required this.icon, required this.path});
  
}


List<Menu> menuList = [

  Menu(title: "Añadir Gasto", subtitle: "Añade tu gasto personal", description: "sdalksdkajshdkjlasdhlsakjdka", icon: Icon(Icons.monetization_on), path: "/anadirGasto"),
  Menu(title: "Ver Gastos", subtitle: "Ver tus gastos", description: "sdalksdkajshdkjlasdhlsakjdka", icon: Icon(Icons.money_off), path: "/verGastos"),
  Menu(title: "Crear Grupo De Ahorro", subtitle: "Crea tu grupo de ahorro", description: "sdalksdkajshdkjlasdhlsakjdka", icon: Icon(Icons.group), path: "/grupoAhorro"),
];