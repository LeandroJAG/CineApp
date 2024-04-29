import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:prueba/Models/aggcinemodel.dart';

class ProviderCines with ChangeNotifier {
  final String _endpoint =
      "https://carteleracine-91a56-default-rtdb.firebaseio.com/Cine";

  List<Cines> _cines = [];

  List<Cines> get cines => _cines;

  Future<List<Cines>> getAll() async {
    try {
      final response = await http.get(Uri.parse(_endpoint));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        _cines = jsonData.entries.map((entry) {
          return Cines.fromMap(entry.value);
        }).toList();
        notifyListeners();
        return _cines;
      } else {
        throw Exception("Ocurrió algo ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }

  Future<void> deleteCine(String cineId) async {
    try {
      final response =
          await http.delete(Uri.parse('$_endpoint/$cineId.json'));
      if (response.statusCode == 200) {
        _cines.removeWhere((cine) => cine.nombre == cineId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete cine: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting cine: $e');
    }
  }

  Future<String> save(Cines data) async {
    try {
      final url = "$_endpoint.json";
      final response =
          await http.post(Uri.parse(url), body: json.encode(data.toMap()));
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        // Agregar el cine a la lista local después de guardarla en la base de datos
        final newCineId = jsonData['name'];
        final newCine = Cines(
          nombre: newCineId ?? data.nombre,
          latitud: data.latitud,
          longitud: data.longitud,
          resenas: data.resenas,
          peliculaProyectandose: data.peliculaProyectandose,
          horainicio: data.horainicio,
          imagen: data.imagen,
          horarios: data.horarios,
        );
        _cines.add(newCine);

        // Notificar a los listeners que los datos han cambiado
        notifyListeners();

        return newCineId;
      } else {
        throw Exception("Error ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }
}