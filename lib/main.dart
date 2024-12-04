import 'package:flutter/material.dart'; // Biblioteca principal para construir interfaces gráficas
import 'package:go_router/go_router.dart'; // Biblioteca para la navegación basada en rutas
import 'package:provider/provider.dart'; // Biblioteca para la gestión del estado
import 'package:rickandmortyapp/providers/api_provider.dart'; // Proveedor de datos de la API
import 'package:rickandmortyapp/screens/character_screen.dart'; // Pantalla de detalles del personaje
import 'package:rickandmortyapp/screens/home_screen.dart'; // Pantalla principal

// Punto de entrada de la aplicación
void main() => runApp(const MyApp());

// Configuración de las rutas usando GoRouter
final GoRouter _router = GoRouter(
  routes: [
    // Ruta inicial de la aplicación
    GoRoute(
      path: '/', // Ruta raíz (pantalla principal)
      builder: (context, state) {
        return const HomeScreen(); // Renderiza la pantalla principal
      },
      routes: [
        // Ruta secundaria para los detalles de un personaje
        GoRoute(
          path: 'character', // Ruta para la pantalla de detalles del personaje
          builder: (context, state) {
            return const CharacterScreen(); // Renderiza la pantalla de detalles
          },
        )
      ],
    ),
  ],
);

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Proveedor para gestionar el estado global de la API
      create: (context) => ApiProvider(),
      child: MaterialApp.router(
        // Configuración básica de la aplicación
        title: 'Rick And Morty App', // Título de la aplicación
        debugShowCheckedModeBanner: false, // Oculta el banner de depuración
        theme: ThemeData(
          brightness: Brightness.dark, // Tema oscuro para la aplicación
          useMaterial3: true, // Uso del nuevo diseño Material 3
        ),
        routerConfig: _router, // Configuración de las rutas
      ),
    );
  }
}
