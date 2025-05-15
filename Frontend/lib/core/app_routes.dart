import 'package:app_gastos_tp3_grupo8/screens/anadirGasto.dart';
import 'package:app_gastos_tp3_grupo8/screens/crearGrupo.dart';
import 'package:app_gastos_tp3_grupo8/screens/crearGastoGrupo.dart';
import 'package:app_gastos_tp3_grupo8/screens/verGastos.dart';
import 'package:go_router/go_router.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/home.dart';
final appRouter = GoRouter(
  
  initialLocation: '/login',

  routes: [

    GoRoute(path: '/login' ,builder: (context, state) => Login(),),
    GoRoute(path: '/register' ,builder: (context, state) => Register(),),
    GoRoute(path: '/home' ,builder: (context, state) => Home(),),
    GoRoute(path: '/anadirGasto' ,builder: (context, state) => AnadirGasto(),),
    GoRoute(path: '/crearGastoGrupo' ,builder: (context, state) => CrearGastoGrupo(),),
    GoRoute(path: '/verGastos' ,builder: (context, state) => Gastos(),),
    GoRoute(path: '/crearGrupo' ,builder: (context, state) => CrearGrupo(),)

]);