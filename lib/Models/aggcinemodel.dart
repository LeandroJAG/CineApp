import 'dart:convert';

class MapScreenM {
  List<Cines> cinesList = [];

  MapScreenM.fromJsonList(Map<String, dynamic> json) {
    json.forEach((key, val) {
      try {
        final value = Cines.fromMap(val);
        value.nombre = key; // Este es el lugar donde se produce el error
        cinesList.add(value);
      } catch (e) {
        throw Exception(e);
      }
    });
  }
}

class Cines {
  String nombre; // Quitamos 'final' aquí
  final double latitud;
  final double longitud;
  final List<String> resenas;
  final String peliculaProyectandose;
  final String horainicio;
  final String imagen;
  final String horarios;

  Cines({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.resenas,
    required this.peliculaProyectandose,
    required this.horainicio,
    required this.imagen,
    required this.horarios,
  });

  // Método para copiar un cine con un nuevo nombre (para usar después de guardar en la base de datos)
  Cines copyWith({String? nombre}) {
    return Cines(
      nombre: nombre ?? this.nombre,
      latitud: this.latitud,
      longitud: this.longitud,
      resenas: this.resenas,
      peliculaProyectandose: this.peliculaProyectandose,
      horainicio: this.horainicio,
      imagen: this.imagen,
      horarios: this.horarios,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'latitud': latitud,
      'longitud': longitud,
      'resenas': resenas,
      'peliculaProyectandose': peliculaProyectandose,
      'horainicio': horainicio,
      'imagen': imagen,
      'horarios': horarios,
    };
  }

  factory Cines.fromMap(Map<String, dynamic> map) {
    return Cines(
      nombre: map['nombre']?? '',
      latitud: map['latitud']?? 0.0,
      longitud: map['longitud']?? 0.0,
      resenas: map['resenas']?? [],
      peliculaProyectandose: map['peliculaProyectandose']?? '',
      horainicio: map['horainicio']?? '',
      imagen: map['imagen']?? '',
      horarios: map['horarios']?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Cines.fromJson(String source) =>
      Cines.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cines(nombre: $nombre, latitud: $latitud, longitud: $longitud, resenas: $resenas, peliculaProyectandose: $peliculaProyectandose, horainicio: $horainicio, imagen: $imagen, horarios: $horarios)';
  }
}