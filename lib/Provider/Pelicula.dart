import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:prueba/Models/Carteleramodel.dart';

class ProviderPelicula with ChangeNotifier {
  final String _endpoint =
      "https://leanalf.pythonanywhere.com/api/Obtenercarteleras";

  List<Movie> _movies = [];

  List<Movie> get movies => _movies;
  Future<List<Movie>> getAll() async {
    try {
      final response = await http.get(Uri.parse(_endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _movies = data.map((sillaData) => Movie.fromJson(sillaData)).toList();
        notifyListeners();
        return _movies;
      } else {
        throw Exception('Failed to load sillas');
      }
    } catch (e) {
      throw Exception('Error fetching sillas: $e');
    }
  }



  Future<void> deleteMovie(String movieId) async {
  try {
    final response = await http.delete(Uri.parse('$_endpoint/$movieId.json'));
    if (response.statusCode == 200) {
      _movies.removeWhere((movie) => movie.id == movieId);
      notifyListeners();
    } else {
      throw Exception('Failed to delete movie: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error deleting movie: $e');
  }
}
Future<String> save(Movie data) async {
  try {
    final url = "$_endpoint.json";
    final response = await http.post(Uri.parse(url), body: data.toJson());
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      // Agregar la película a la lista local después de guardarla en la base de datos
      final newMovieId = jsonData['name'];
      final newMovie = data.copyWith(id: newMovieId);
      _movies.add(newMovie);
      notifyListeners();

      return newMovieId;
    } else {
      throw Exception("Error ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error $e");
  }
}

  void addMovie(Movie newMovie) {}

}






