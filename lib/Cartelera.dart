import 'package:flutter/material.dart';

class Movie {
  final String title;
  final String director;
  final String imageUrl;
  final String description;
  final String horario;
  final List<String> categories;
  bool isFavorite;
  String review;

  Movie({
    required this.title,
    required this.director,
    required this.imageUrl,
    required this.description,
    required this.horario,
    this.categories = const [],
    this.isFavorite = false,
    this.review = '',
  });

  static fromJson(data) {}
}

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

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
      categories: ['aventura', 'estreno', 'accion'],
    ),
    // Add more movies with categories
  ];

  @override
  void initState() {
    super.initState();
    // Example of adding more movies when the app starts
    List<Movie> additionalMovies = [
      Movie(
        title: 'Nombre de la película',
        director: 'Nombre del director',
        imageUrl: 'ruta/a/la/imagen.jpg',
        description: 'Descripción de la película',
        horario: 'Horario de la película',
        categories: ['Categoría 1', 'Categoría 2'],
      ),
      // Add more movies here
    ];
    addMovies(additionalMovies);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartelera',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white, // Cambio de fondo a blanco
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  movies[index].title,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Director: ${movies[index].director}'),
                    Text('Horario: ${movies[index].horario}'),
                    const SizedBox(height: 4.0),
                    Text(
                      'Categorías: ${movies[index].categories.join(', ')}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 100, 100, 100),
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                leading: _buildMovieImage(movies[index].imageUrl),
                trailing: _buildButtons(context, index),
                onTap: () {
                  _navigateToMovieDetails(context, movies[index]);
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
      ),
    );
  }

  Widget _buildMovieImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        imageUrl,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildButtons(BuildContext context, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            movies[index].isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            _toggleFavorite(index);
          },
        ),
        IconButton(
          icon: const Icon(Icons.rate_review),
          onPressed: () {
            _openReviewScreen(context, movies[index]);
          },
        ),
      ],
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      movies[index].isFavorite = !movies[index].isFavorite;
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
    String imageUrl;
    if (movie.title == 'Spider-Man No Way Home') {
      imageUrl = 'assets/images/Spiderman.png';
    } else if (movie.title == 'John Wick 4') {
      imageUrl = 'assets/images/johnwick2.jpeg';
    } else {
      imageUrl = 'default_image_url';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
         builder: (context) => MovieDetailScreen(
          movie: movie,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  void addMovies(List<Movie> newMovies) {
    setState(() {
      movies.addAll(newMovies);
    });
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
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  final String imageUrl;

  const MovieDetailScreen({super.key, required this.movie, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMovieImage(imageUrl),
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
                movie.description,
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
                movie.review.isNotEmpty ? movie.review : 'No hay reseña disponible.',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Categorías: ${movie.categories.join(', ')}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],),
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

  const ReviewScreen({super.key, required this.movie});

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
            Text(
              'Película: ${widget.movie.title}',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Escribe tu reseña aquí...',
                border: OutlineInputBorder(),
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
}

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _horarioController = TextEditingController();
  final List<String> _categories = [];

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
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _directorController,
              decoration: InputDecoration(labelText: 'Director'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'URL de la imagen'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _horarioController,
              decoration: InputDecoration(labelText: 'Horario'),
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
        _imageUrlController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _horarioController.text.isNotEmpty &&
        _categories.isNotEmpty) {
      Movie newMovie = Movie(
        title: _titleController.text,
        director: _directorController.text,
        imageUrl: _imageUrlController.text,
        description: _descriptionController.text,
        horario: _horarioController.text,
        categories: List.from(_categories),
      );

      Navigator.pop(context, newMovie);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Por favor complete todos los campos y seleccione al menos una categoría.'),
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