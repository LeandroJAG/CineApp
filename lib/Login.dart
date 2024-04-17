import 'package:flutter/material.dart';
import 'package:prueba/Map.dart';
import 'package:prueba/Models/Usuario.dart';
import 'package:prueba/Provider/Registrouser.dart';
import 'package:prueba/Provider/UserProvider.dart';
import 'package:prueba/Registe.dart';
import 'package:prueba/Sharepreference/Sharepreference.dart';

class LoginScreen extends StatefulWidget {
  static const String nombre = 'login';
    final prefs = PreferenciaUsuario();

  // controladores de edición de texto
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // método para iniciar sesión
  void signUserIn(BuildContext context) async {
    var prefs;
    await prefs.saveUserData(usernameController.text, passwordController.text);
    prefs.usuario = usernameController.text;
    prefs.contrasena = passwordController.text;
    print(prefs.usuario);
    Navigator.of(context).pushNamed(MapScreen.nombre);
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
 // FirebaseProvider  usuarioProvider = FirebaseProvider();
  AuthenticationServices service = AuthenticationServices();
  late Future < List<UsuarioModel>> userList;
 @override
  void initState() {
    super.initState();
    userList=service.getAll();
    

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CineApp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 100,
                color: const Color.fromARGB(255, 117, 56, 56),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email/Username',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => email = value,
              ),
              SizedBox(height: 12),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => password = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    
                  //  usuarioProvider.login(email!, password!);
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                    );
                  }
                },
                child: Text('INICIAR'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationScreen()),
                  );
                },
                child: Text('NO TIENES CUENTA? DALE AQUÍ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}