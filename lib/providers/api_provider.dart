import 'package:flutter/material.dart'; // Biblioteca principal para construir interfaces gráficas
import 'package:rickandmortyapp/models/character_model.dart'; // Modelo de datos para los personajes
import 'package:http/http.dart' as http; // Biblioteca para realizar solicitudes HTTP

// Proveedor de la API que utiliza ChangeNotifier para gestionar el estado
class ApiProvider with ChangeNotifier {
  // URL base para la API de Rick and Morty
  final url = 'rickandmortyapi.com';

  // Lista que almacenará los personajes obtenidos de la API
  List<Character> characters = [];

  // Método asincrónico para obtener los datos de los personajes
  Future<void> getCharacter() async {
    // Realiza una solicitud GET a la API para obtener los personajes
    final result = await http.get(Uri.https(url, "/api/character"));

    // Convierte la respuesta JSON en objetos de tipo Character
    final response = characterResponseFromJson(result.body);

    // Agrega los resultados obtenidos a la lista de personajes
    characters.addAll(response.results!);

    // Notifica a los widgets dependientes que los datos han cambiado
    notifyListeners();
  }
}

