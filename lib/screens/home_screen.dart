import 'package:flutter/material.dart'; // Biblioteca principal de Flutter para interfaces gráficas
import 'package:go_router/go_router.dart'; // Biblioteca para navegación basada en rutas
import 'package:provider/provider.dart'; // Biblioteca para gestión del estado
import 'package:rickandmortyapp/providers/api_provider.dart'; // Proveedor personalizado para la API

// Clase principal para la pantalla inicial
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    // Inicializa el proveedor de API para cargar los datos de personajes
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider
        .getCharacters(page); // Llama al método para obtener los personajes
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await apiProvider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Accede al proveedor para escuchar los cambios en los datos de personajes
    final apiProvider = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rick And Morty', // Título de la pantalla
          style: TextStyle(fontWeight: FontWeight.bold), // Negrita en el texto
        ),
        centerTitle: true, // Centra el título en la barra de navegación
      ),
      body: SizedBox(
        height: double.infinity, // Ocupa todo el alto disponible
        width: double.infinity, // Ocupa todo el ancho disponible
        // Verifica si la lista de personajes no está vacía
        child: apiProvider.characters.isNotEmpty
            ? CharacterList(
                apiProvider: apiProvider,
                isLoading: isLoading,
                scrollController: scrollController,
              ) // Muestra la lista de personajes
            : const Center(
                child: CircularProgressIndicator(), // Indicador de carga
              ),
      ),
    );
  }
}

// Widget para mostrar la lista de personajes en formato de cuadrícula
class CharacterList extends StatelessWidget {
  const CharacterList(
      {super.key,
      required this.apiProvider,
      required this.scrollController,
      required this.isLoading});

  final ApiProvider
      apiProvider; // Proveedor que contiene los datos de personajes
  final ScrollController scrollController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Define 2 columnas en la cuadrícula
        childAspectRatio: 0.80, // Relación de aspecto de cada celda
        mainAxisSpacing: 10, // Espaciado vertical entre celdas
        crossAxisSpacing: 10, // Espaciado horizontal entre celdas
      ),
      itemCount: isLoading
          ? apiProvider.characters.length + 2
          : apiProvider.characters.length, // Número de elementos en la lista
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index < apiProvider.characters.length) {
          final character =
              apiProvider.characters[index]; // Obtiene cada personaje

          return GestureDetector(
            onTap: () {
              context.go('/character', extra: character); // Navega a los detalles del personaje
            },
            child: Card(
              child: Column(
                children: [
                  // Imagen con esquinas redondeadas
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(15), // Redondea las esquinas
                    child: Hero(
                      tag: character.id!,
                      child: FadeInImage(
                        placeholder: const AssetImage(
                            'assets/images/rick-and-morty.gif'), // Imagen temporal mientras carga
                        image: NetworkImage(character
                            .image!), // Imagen del personaje desde la API
                      ),
                    ),
                  ),
                  // Nombre del personaje
                  Text(
                    character.name!,
                    style: const TextStyle(
                      fontSize: 16, // Tamaño del texto
                      overflow: TextOverflow
                          .ellipsis, // Recorta si el texto es demasiado largo
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
