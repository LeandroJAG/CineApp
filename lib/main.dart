import 'package:flutter/material.dart';
import 'package:prueba/Cartelera.dart';
import 'package:prueba/Login.dart';
import 'package:prueba/Map.dart';
import 'package:prueba/Registe.dart';
import 'package:prueba/Sharepreference/Sharepreference.dart';
import 'package:prueba/Welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciaUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.nombre,
      routes: {
        LoginScreen.nombre: (context) => LoginScreen(),
        MyApp1.nombre: (context) => const MyApp1(),
        MapScreen.nombre: (context) => const MapScreen(),
        RegistrationScreen.nombre: (context) => const RegistrationScreen(),
        WelcomeScreen.nombre: (context) => WelcomeScreen(),
      },
      home: LoginScreen(),
    );
  }
}
