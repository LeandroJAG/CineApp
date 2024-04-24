import 'package:flutter/material.dart';
import 'package:prueba/Map.dart';

import 'package:prueba/Models/Carteleramodel.dart';
import 'package:http/http.dart' as http;
import 'package:prueba/Provider/Pelicula.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyApp1 extends StatefulWidget {
  const MyApp1({Key? key});
  static const String nombre = 'cartelera';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  final List<Movie> movies = [
    Movie(
      title: 'Spider-Man No Way Home',
      director: 'Jon Watts',
      imageUrl: 'assets/images/spiderman1.jpeg',
      description:
          'Es una película estadounidense de superhéroes basada en el personaje Spider-Man, de Marvel Comics...',
      horario: '10:00AM - 1:00PM',
      categories: 'aventura',
      isFavorite: false,
      review: '',
    ),
    // Add more movies with categories
  ];
  late Future<List<Movie>> MovieMList;

  @override
  void initState() {
    MovieMList = ProviderPelicula.getAll();
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  return FutureBuilder<List<Movie>>(
    future: MovieMList,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else if (snapshot.hasData) {
        List<Movie>? movieMList = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cartelera de Películas',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: movieMList?.length ?? 0,
            itemBuilder: (context, index) {
              Movie movie = movieMList![index];
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    movie.title ?? "",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Director: ${movie.director}'),
                      Text('Horario: ${movie.horario}'),
                      const SizedBox(height: 4.0),
                      Text(
                        'Categorías: ${movie.categories}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 100, 100, 100),
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  leading: _buildMovieImage(movie.imageUrl ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          movie.isFavorite ?? false
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _toggleFavorite(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.rate_review),
                        onPressed: () {
                          _openReviewScreen(context, movie);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteMovie(movie);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _navigateToMovieDetails(context, movie);
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addNewMovie,
            tooltip: 'Agregar película',
            child: Icon(Icons.add),
          ),
        );
      } else {
        return Center(
          child: Text('No se encontraron datos.'),
        );
      }
    },
  );
}


  Widget _buildMovieImage(String imageUrl) {
    print('imageUrl $imageUrl');
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        imageUrl,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      ),
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      if (movies[index].isFavorite != null) {
        movies[index].isFavorite = !(movies[index].isFavorite!);
      }
    });
  }

  void _openReviewScreen(BuildContext context, Movie movie) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(movie: movie),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        movie.review = result;
      });
    }
  }

  void _navigateToMovieDetails(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movie: movie),
      ),
    );
  }

  void _addNewMovie() async {
    final newMovie = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMovieScreen(),
      ),
    );

    if (newMovie != null && newMovie is Movie) {
      setState(() {
        movies.add(newMovie);
      });
    }
  }

  void _deleteMovie(Movie movie) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro de que deseas eliminar "$movie"?'),
        actions: [
          TextButton(
            onPressed: () async {
              // Eliminar la película de la base de datos
             var eli= ProviderPelicula.delete(movie.id??'');
             Navigator.of(context).pushNamed(MapScreen.nombre);
            },
            child: Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title ?? ""),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMovieImage(movie.imageUrl ?? ""),
              const SizedBox(height: 16.0),
              Text(
                'Titulo: ${movie.title}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Director: ${movie.director}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Horario: ${movie.horario}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Descripción:',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                movie.description ?? "",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Reseña:',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                movie.review != null && movie.review!.isNotEmpty
                    ? movie.review!
                    : 'No hay reseña disponible.',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Categorías: ${movie.categories}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.asset(
        imageUrl,
        width: double.infinity,
        height: 200.0,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ReviewScreen extends StatefulWidget {
  final Movie movie;

  ReviewScreen({Key? key, required this.movie});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Reseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieImage(widget
                .movie.imageUrl??""), // Aquí se muestra la imagen de la película
            const SizedBox(height: 16.0),
            Text(
              'Película: ${widget.movie.title}',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Escribe tu reseña aquí...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: const Color.fromARGB(
                    255, 202, 224, 240), // Fondo azul claro
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: const Text('Guardar Reseña'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final service = ProviderPelicula();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _horarioController = TextEditingController();
  final List<String> _categories = [];
  late String _selectedImageUrl;

  @override
  void initState() {
    super.initState();
    _selectedImageUrl =
        'assets/images/spiderman1.jpeg'; // Set default image URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Película'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                filled: true,
                fillColor: const Color.fromARGB(
                    255, 202, 224, 240), // Fondo azul claro
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // Sin bordes
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _directorController,
              decoration: InputDecoration(
                labelText: 'Director',
                filled: true,
                fillColor: const Color.fromARGB(
                    255, 202, 224, 240), // Fondo azul claro
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // Sin bordes
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedImageUrl,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedImageUrl = value;
                  });
                }
              },
              items: [
                'assets/images/troya.jpeg',
                'assets/images/thehungergame.png',
                'assets/images/poster-los-vengadores.jpg',
                'assets/images/jumanji.jpg',
                'assets/images/avatar.png',
                'assets/images/Spiderman.png',
                'assets/images/johnwick.jpeg',
                'assets/images/spiderman1.jpeg',
                'assets/images/johnwick2.jpeg',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'URL de la imagen',
                filled: true,
                fillColor: Colors.blue[50], // Fondo azul claro
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // Sin bordes
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                filled: true,
                fillColor: Colors.blue[50], // Fondo azul claro
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // Sin bordes
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _horarioController,
              decoration: InputDecoration(
                labelText: 'Horario',
                filled: true,
                fillColor: Colors.blue[50], // Fondo azul claro
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // Sin bordes
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Categorías'),
            Wrap(
              children: [
                _buildCategoryChip('Aventura'),
                _buildCategoryChip('Acción'),
                _buildCategoryChip('Comedia'),
                _buildCategoryChip('Drama'),
                _buildCategoryChip('Romance'),
                _buildCategoryChip('Ciencia Ficción'),
                _buildCategoryChip('Animación'),
                _buildCategoryChip('Fantasía'),
                _buildCategoryChip('Terror'),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveMovie,
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(category),
        selected: _categories.contains(category),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _categories.add(category);
            } else {
              _categories.remove(category);
            }
          });
        },
      ),
    );
  }

  void _saveMovie() {
    if (_titleController.text.isNotEmpty &&
        _directorController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _horarioController.text.isNotEmpty &&
        _categories.isNotEmpty) {
      Movie newMovie = Movie(
        title: _titleController.text,
        director: _directorController.text,
        imageUrl: _selectedImageUrl,
        description: _descriptionController.text,
        horario: _horarioController.text,
        categories: 'Accion ',
      );
      service.save(newMovie);
      Navigator.pop(context, newMovie);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Por favor complete todos los campos y seleccione al menos una categoría.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
