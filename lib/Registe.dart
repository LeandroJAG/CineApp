import 'package:flutter/material.dart';
import 'package:prueba/Login.dart';
import 'package:prueba/Models/Usuario.dart';
import 'package:prueba/Provider/Registrouser.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String nombre = 'registe';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final usuarioProvider = FirebaseProvider();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👈Regresar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/cine.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTextFormField(_firstNameController, 'Nombre',
                  'ingresa tu nombre'),
              _buildTextFormField(_lastNameController, 'Apellido',
                  'Ingresa tu apellido'),
              _buildTextFormField(_emailController, 'Correo Electrónico',
                  'Ingresa tu correo'),
              _buildTextFormField(_passwordController, 'Contraseña',
                  'Ingresa tu contraseña',
                  obscureText: true),
              _buildTextFormField(_addressController, 'Dirección',
                  'Ingresa tu dirección'),
              _buildTextFormField(_phoneController, 'Teléfono',
                  'Ingresa tu número de teléfono'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      String hint, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obligatorio';
          }
          return null;
        },
      ),
    );
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      UsuarioModel usuario = UsuarioModel(
        contrasena: _passwordController.text,
        correo: _emailController.text,
        direccion: _addressController.text,
        nombre: _firstNameController.text,
        telefono: _phoneController.text,
        apellido: _lastNameController.text,
      );

      usuarioProvider.createUsuario(usuario);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }
}