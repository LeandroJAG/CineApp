class User {
  List<UsuarioModel> userList = [];
  UsuarioModel? usersAuthenticated; 
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
    throw Exception("Por favor verificar");
    } else {
    //  print(mapList);
   //   print(password);
      mapList.forEach((key, val) {
         // print(val);
        try {
          final value = UsuarioModel.fromMap(val);
          if (value.correo == username && value.contrasena == password) {
            value.id=key;
           usersAuthenticated=value;
          } else {
           
          }
        } catch (e) {
          throw Exception("Error de servidor ");
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

  static fromJsonListUserAuthenticate(jsonData) {}

  static fromJsonList(jsonData) {}
}
