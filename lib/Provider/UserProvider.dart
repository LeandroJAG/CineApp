import 'dart:convert';

import 'package:prueba/Models/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FirebaseProvider {
   
  final String _endpoint =
      "https://carteleracine-91a56-default-rtdb.firebaseio.com/Usuarios.json";

  Future<Map<String, dynamic>> fetchUsuarios() async {
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load usuarios');
    }
  }
}

class AuthenticationServices {
 
  final FirebaseProvider _firebaseProvider = FirebaseProvider();

  Future<bool> signIn(String email, String password) async {
    final usuarios = await _firebaseProvider.fetchUsuarios();
    final usuario = usuarios.values.firstWhere(
        (user) => user['correo'] == email && user['contrasena'] == password,
        orElse: () => null);
    if (usuario != null) {
      // Guardar el estado de la sesión en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('correo', email);
      prefs.setString('pin', password);
    }

    return usuario != null;
  }

  Future<List<UsuarioModel>> getAll() async {
    try {
      final String _endpoint =
          "https://carteleracine-91a56-default-rtdb.firebaseio.com/Usuarios.json";
      final response = await http.get(Uri.parse(_endpoint));
      if (response.statusCode == 200) {
        print("entro");
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        final listData = User.fromJsonList(jsonData);
        //state = listData.userList;
        return listData.userList;
      } else {
        throw Exception("Ocurrió algo ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }
    Future<UsuarioModel?> authenticate(String username, String password) async {
      print("entro al provider");
   
    try {
      final url = "https://carteleracine-91a56-default-rtdb.firebaseio.com/Usuarios.json";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        //print(response.body);
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        
        final authenticatedUser =
            User.fromJsonListUserAuthenticate(jsonData, username, password);
            if (authenticatedUser.usersAuthenticated==null) {
            
             throw Exception("Usuario no registrado");
            }
          
      
        return authenticatedUser.usersAuthenticated;
      } else {
        throw Exception("Ocurrió algo ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }


}
