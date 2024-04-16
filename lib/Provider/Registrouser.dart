import 'package:http/http.dart' as http; // Importa la librería para hacer peticiones HTTP
import 'dart:convert';
import 'package:prueba/Models/Usuario.dart';
// Importa la librería para manejar JSON

class FirebaseProvider {
  final String _endpoint = "https://carteleracine-91a56-default-rtdb.firebaseio.com/Usuarios.json";

  
  Future<Map<String, dynamic>> fetchUsuarios() async {
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load usuarios');
    }
  }
  Future<bool> createUsuario(UsuarioModel usuario) async {
    try {
      final url = Uri.parse(_endpoint);
      final response = await http.post(
        url,
        body: jsonEncode(usuario.toJson()),
      );

      if (response.statusCode == 200) {
        return true; // Registro exitoso
      } else {
        throw Exception("Error creating usuario: ${response.statusCode}");
      }
    } catch (e) {
      return false;
    }
  }

  void login(String s, String t) {}
}

class AuthenticationService {
  final FirebaseProvider _firebaseProvider = FirebaseProvider();

  Future<bool> signIn(String email, String password) async {
    final usuarios = await _firebaseProvider.fetchUsuarios();
    final usuario = usuarios.values.firstWhere((user) => user['correo'] == email && user['contrasena'] == password, orElse: () => null);
    
    return usuario != null;
  }
}
