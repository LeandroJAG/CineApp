import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/Cartelera.dart';
import 'package:prueba/Login.dart';
import 'package:prueba/Map.dart';
import 'package:prueba/Registe.dart';
import 'package:prueba/Sharepreference/Sharepreference.dart';
import 'package:prueba/Welcome.dart';
import 'package:prueba/Provider/Pelicula.dart'; // Importa el proveedor aquí

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciaUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderPelicula>( // Añade el proveedor aquí
      create: (_) => ProviderPelicula(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CineApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: LoginScreen.nombre,
        routes: {
          LoginScreen.nombre: (context) => LoginScreen(),
          MapScreen.nombre: (context) => const MapScreen(),
          RegistrationScreen.nombre: (context) => const RegistrationScreen(),
          WelcomeScreen.nombre: (context) => WelcomeScreen(),
        },
        home: LoginScreen(),
      ),
    );
  }
}
