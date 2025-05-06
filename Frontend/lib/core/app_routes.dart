
import 'package:go_router/go_router.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/home.dart';
final appRouter = GoRouter(
  
  initialLocation: '/register',

  routes: [

    GoRoute(path: '/login' ,builder: (context, state) => Login(),),
    GoRoute(path: '/register' ,builder: (context, state) => Register(),),
    GoRoute(path: '/home' ,builder: (context, state) => Home(),)

]);