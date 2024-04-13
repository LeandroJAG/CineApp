class UsuarioModel {
  final String contrasena;
  final String correo;
  final String direccion;
  final String nombre;
  final String telefono;
  final String apellido;

  UsuarioModel({
    required this.contrasena,
    required this.correo,
    required this.direccion,
    required this.nombre,
    required this.telefono,
    required this.apellido,
  });

  Map<String, dynamic> toJson() {
    return {
      "contrasena": contrasena,
      "correo": correo,
      "direccion": direccion,
      "nombre": nombre,
      "telefono": telefono,
      "apellido": apellido,
    };
  }
}