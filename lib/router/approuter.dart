import 'package:pruebacorta2/presentation/screens/home/home_screen.dart';


final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/ver_vehiculos',
      builder: (context, state) => VerVehiculosScreen(),
    ),
    GoRoute(
      path: '/buscar_vehiculo',
      builder: (context, state) => BuscarVehiculoScreen(),
    ),
    GoRoute(
      path: '/borrar_vehiculo',
      builder: (context, state) => BorrarVehiculoScreen(),
    ),
  ],
);