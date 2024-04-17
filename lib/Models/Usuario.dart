class User {
  List<UsuarioModel> userList = [];
  List<UsuarioModel> usersAuthenticatedList = [];
  User.fromJsonList(json) {
    if (json == null) {
      return;
    } else {
      json.list.forEach((key, val) {
        if (json is Map<String, dynamic>) {
          try {
            final value = UsuarioModel.fromMap(json);

            value.id = key;
            userList.add(value);
          } catch (e) {
            throw Error();
          }
        }
      });
    }
  }
    User.fromJsonListUserAuthenticate(mapList, String username, String password) {
    if (mapList == null || username == "" || password == "") {
    
      return;
    } else {
      mapList.forEach((key, val) {
        try {
          final value = UsuarioModel.fromMap(val);
          if (value.correo == username && value.contrasena == password) {
            value.id=key;
            usersAuthenticatedList.add(value);
          } else {
           
          }
        } catch (e) {
          throw Exception("Usuario no encontrado o incorrectos");
        }
      });
    }
  }
}

class UsuarioModel {
  String? contrasena;
  String? correo;
  String? direccion;
  String? nombre;
  String? telefono;
  String? apellido;
  String? id;

  UsuarioModel({
    this.contrasena,
    this.correo,
    this.direccion,
    this.nombre,
    this.telefono,
    this.apellido,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      "contrasena": contrasena,
      "correo": correo,
      "direccion": direccion,
      "nombre": nombre,
      "telefono": telefono,
      "apellido": apellido,
      "id": id,
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'],
      apellido: map['apellido'],
      telefono: map['telefono'],
      nombre: map['nombre'],
      direccion: map['direccion'],
      correo: map['correo'],
      contrasena: map['contrasena'],
    );
  }
}
