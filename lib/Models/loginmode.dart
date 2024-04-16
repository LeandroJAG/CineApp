class UsuarioModel1 {
  final String contrasena;
  final String correo;


  UsuarioModel1({
    required this.contrasena,
    required this.correo,
  });

  Map<String, dynamic> toJson() {
    return {
      "contrasena": contrasena,
      "correo": correo,

    };
  }
}