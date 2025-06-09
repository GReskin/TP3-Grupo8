import 'package:app_gastos_tp3_grupo8/screens/anadirGasto.dart';
import 'package:app_gastos_tp3_grupo8/screens/anadirGastoGeneral.dart';
import 'package:app_gastos_tp3_grupo8/screens/crearGrupo.dart';
import 'package:app_gastos_tp3_grupo8/screens/crearGastoGrupo.dart';
import 'package:app_gastos_tp3_grupo8/screens/verGastos.dart';
import 'package:app_gastos_tp3_grupo8/screens/verGastosGeneral.dart';
import 'package:app_gastos_tp3_grupo8/screens/verGastosGrupales.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/home.dart';
import 'package:flutter/material.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => Login()),
    GoRoute(path: '/register', builder: (context, state) => Register()),
    GoRoute(path: '/home', builder: (context, state) => Home()),
    GoRoute(path: '/anadirGasto', builder: (context, state) => AnadirGasto()),
    GoRoute(
      path: '/crearGastoGrupo',
      builder: (context, state) => CrearGastoGrupo(),
    ),
    GoRoute(path: '/verGastos', builder: (context, state) => Gastos()),
    // Ruta para ver gastos grupales, recibe el id del grupo por parámetro
    GoRoute(
      path: '/verGastosGrupales/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        if (id == null) {
          return const Scaffold(
            body: Center(child: Text('ID de grupo inválido')),
          );
        }
        return VerGastosGrupales(idGrupo: id);
      },
    ),
    // Ruta para ver gastos generales del usuario actual (async)
    GoRoute(
      path: '/verGastosGeneral',
      builder: (context, state) {
        return FutureBuilder<int?>(
          future: _getUsuarioId(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final usuarioId = snapshot.data;
            if (usuarioId == null) {
              return const Scaffold(
                body: Center(child: Text('Usuario no identificado')),
              );
            }
            return VerGastosGeneral(usuarioId: usuarioId);
          },
        );
      },
    ),
    GoRoute(path: '/crearGrupo', builder: (context, state) => CrearGrupo()),
    GoRoute(
      path: '/gastosGenerales',
      builder: (context, state) => const AnadirGastoGeneral(),
    ),
  ],
);

Future<int?> _getUsuarioId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('idusuario');
}
