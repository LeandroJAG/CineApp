import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prueba/Map.dart';

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  
  final String _endpoint =
      "https://carteleracine-91a56-default-rtdb.firebaseio.com/Cine";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: Center(
        child: Text('Map content goes here'),
      ),
    );
  }
  Future<void> agregarCine(dynamic data) async {
    try {
      final String _endpoint =
      "https://carteleracine-91a56-default-rtdb.firebaseio.com/Cine";
      String nombre;
      double latitud;
      double longitud;

      if (data is String) {
        Map<String, dynamic> cineData = json.decode(data);
        nombre = cineData['nombre'];
        latitud = cineData['latitud'];
        longitud = cineData['longitud'];
      } else if (data is Uri) {
        http.Response response = await http.get(data);
        if (response.statusCode == 200) {
          Map<String, dynamic> cineData = json.decode(response.body);
          nombre = cineData['nombre'];
          latitud = cineData['latitud'];
          longitud = cineData['longitud'];
        } else {
          throw Exception('Failed to load data from endpoint');
        }
      } else {
        throw Exception('Invalid data type');
      }

      if (nombre.isNotEmpty && latitud != 0.0 && longitud != 0.0) {
        setState(() {
          local.add(Cines(
            nombre: nombre,
            latitud: latitud,
            longitud: longitud,
            resenas: [],
            peliculaProyectandose: '',
            horainicio: '',
            imagen: 'assets/images/nuevo_cine.png',
            horarios: '',
          ));
        });
      } else {
        // Manejar el caso en el que no se proporcionan todos los datos necesarios
      }
    } catch (e) {
      // Manejar errores
      print('Error: $e');
    }
  }

  Future<void> agregarCineDesdeJson(String jsonCine) async {
    try {
      await agregarCine(jsonCine);
    } catch (e) {
      // Manejar errores
      print('Error: $e');
    }
  }

  Future<void> agregarCineDesdeEndpoint(Uri endpoint) async {
    try {
      await agregarCine(endpoint);
    } catch (e) {
      // Manejar errores
      print('Error: $e');
    }
  }
}
