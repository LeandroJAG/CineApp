import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cine {
  final String nombre;
  final double latitud;
  final double longitud;

  Cine({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });
}

class CinemaProvider extends ChangeNotifier {
  // Lista de cines
  List<Cine> _cines = [];

  List<Cine> get cines => _cines;

  Future<void> agregarCineDesdeJson(String jsonCine) async {
    try {
      Map<String, dynamic> cineData = json.decode(jsonCine);
      String nombre = cineData['nombre'];
      double latitud = cineData['latitud'];
      double longitud = cineData['longitud'];

      if (nombre.isNotEmpty && latitud != 0.0 && longitud != 0.0) {
        _cines.add(Cine(
          nombre: nombre,
          latitud: latitud,
          longitud: longitud,
        ));
        notifyListeners();
      } else {
        throw Exception('Faltan datos necesarios para agregar el cine');
      }
    } catch (e) {
      print('Error al agregar cine desde JSON: $e');
      throw Exception('Error al agregar el cine');
    }
  }

  Future<void> agregarCineDesdeEndpoint(Uri endpoint) async {
    try {
      http.Response response = await http.get(endpoint);
      if (response.statusCode == 200) {
        Map<String, dynamic> cineData = json.decode(response.body);
        String nombre = cineData['nombre'];
        double latitud = cineData['latitud'];
        double longitud = cineData['longitud'];

        if (nombre.isNotEmpty && latitud != 0.0 && longitud != 0.0) {
          _cines.add(Cine(
            nombre: nombre,
            latitud: latitud,
            longitud: longitud,
          ));
          notifyListeners();
        } else {
          throw Exception('Faltan datos necesarios para agregar el cine');
        }
      } else {
        throw Exception('Fallo al cargar datos desde el endpoint');
      }
    } catch (e) {
      print('Error al agregar cine desde el endpoint: $e');
      throw Exception('Error al agregar el cine');
    }
  }
}
