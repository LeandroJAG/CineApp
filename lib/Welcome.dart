import 'package:flutter/material.dart';
import 'package:prueba/Login.dart';

class WelcomeScreen extends StatelessWidget {
  static const String nombre = 'welcome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CineAPP'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cine.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BIENVENIDO ',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 134, 133, 133), 
                ),
              ),
              SizedBox(height: 10),
              Text(
                'A TU',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 134, 133, 133), 
                ),
              ),
              SizedBox(height: 10),
              Text(
                'APP DE CINE FAVORITO',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 134, 133, 133), 
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: 150, // Ancho deseado del botón
                height: 50, // Alto deseado del botón
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Bienvenido'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}