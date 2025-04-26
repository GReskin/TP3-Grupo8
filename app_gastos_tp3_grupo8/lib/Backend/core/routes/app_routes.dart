
import 'package:go_router/go_router.dart';
import '../../../Frontend/presentation/screens/login.dart';
import '../../../Frontend/presentation/screens/register.dart';
import '../../../Frontend/presentation/screens/home.dart';
final appRouter = GoRouter(
  
  initialLocation: '/register',

  routes: [

    GoRoute(path: '/login' ,builder: (context, state) => Login(),),
    GoRoute(path: '/register' ,builder: (context, state) => Register(),),
    GoRoute(path: '/home' ,builder: (context, state) => Home(),)

]);