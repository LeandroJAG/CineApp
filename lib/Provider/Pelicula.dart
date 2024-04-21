import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba/Models/Carteleramodel.dart';

class ProviderPelicula {
  final String _endpoint =
      "https://carteleracine-91a56-default-rtdb.firebaseio.com/Pelicula";

  Future<String> save(Movie data) async {
    try {
      final url = "$_endpoint/Residente.json";
      final response = await http.post(Uri.parse(url), body: data.toJson());
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        return jsonData['name'];
      } else {
        throw ("Error ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }
}
