import 'dart:convert';
 
import 'package:prueba/Models/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
 
class FirebaseProvider {
   
  final String _endpoint =
      "http://leanalf.pythonanywhere.com/";
 
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
          "http://leanalf.pythonanywhere.com/";
      final response = await http.get(Uri.parse(_endpoint));
      if (response.statusCode == 200) {
       // print("entro");
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
      final url = "http://leanalf.pythonanywhere.com/";
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
 
 
class AuthService {
  final String _baseUrl = 'http://leanalf.pythonanywhere.com/api/';
 
  Future<bool> signIn(String correo, String contrasena) async {
  try {
    final url = Uri.parse('$_baseUrl/loginusuarios');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
    );
 
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      print("token");
      print(token);
      // Guardar token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setInt('usuario_id', data['usuario_id']);
      await prefs.setBool('isLoggedIn', true);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error en signIn carita: $e');
    return false;
  }
}
}