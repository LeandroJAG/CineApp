import 'package:flutter/material.dart';
import 'package:prueba/Map.dart';
import 'package:prueba/Registe.dart';
import 'package:prueba/Provider/UserProvider.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool isPassword;

  

  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 202, 224, 241),
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.blue,
        obscureText: isPassword, // Cambio aquí
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.blue,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  static const String nombre = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false; // Variable para indicar si está cargando
  AuthenticationServices au = AuthenticationServices();
  final AuthService _authService = AuthService();

  void _login(BuildContext context) async {
    final String correo = email;
    final String contrasena = password;
    final success = await _authService.signIn(correo, contrasena);
    if (success) {
      print('Usuario y contraseña correctos');
      Navigator.of(context)
      .pushNamed(MapScreen.nombre);
      
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correo o contraseña incorrectossss')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image Container with all corners semi-circular
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(30), // Make all corners semi-circular
                  child: Container(
                    width: double.infinity,
                    height: 150, // Ajusta la altura aquí
                    child: Image.asset(
                      'assets/images/cine.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Header
                Column(
                  children: [
                    Text(
                      '🎬 Bienvenido',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '¡Desbloquea experiencias cinematográficas!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RoundedInputField(
                        hintText: "Email",
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(height: 12),
                      RoundedInputField(
                        hintText: "Contraseña",
                        onChanged: (value) {
                          password = value;
                        },
                        icon: Icons.lock,
                        isPassword: true, // Cambio aquí
                      ),
                      SizedBox(height: 20),
                      // Login button
                      SizedBox(
                        width: 200.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color.fromARGB(255, 202, 224, 241),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  'INICIAR',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Color.fromARGB(255, 12, 27, 39)),
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                // Divider with "Únete" text and split horizontal line
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        height: 20,
                        thickness: 2,
                        color: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Únete',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 20,
                        thickness: 2,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                // Register and local user options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()),
                            );
                          },
                          icon: Icon(Icons.person_add_alt_1_outlined,
                              color: Colors.blue),
                          iconSize: 50,
                        ),
                        Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen()),
                            );
                            // Add functionality for local user
                          },
                          icon: Icon(Icons.person_outline, color: Colors.blue),
                          iconSize: 50,
                        ),
                        Text(
                          'Modo Invitado',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}