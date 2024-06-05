import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prueba/Cartelera.dart';
import 'package:prueba/Login.dart';
import 'package:prueba/Models/aggcinemodel.dart';
import 'package:prueba/Provider/Agregarcine.dart';

import 'package:prueba/Sharepreference/Sharepreference.dart'; // Importa tu provider

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGFuaWVsanIxMSIsImEiOiJjbG5lcXhiYTgwZThhMmpvNGtlNG1vcTdxIn0.xLcplNW4L11ON3Ekf3wpaQ';

class MapScreen extends StatefulWidget {
  static const String nombre = 'mapa';

  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final prefs = PreferenciaUsuario();
  final provider = ProviderCines(); // Instancia de tu provider
  bool showCineDetails = false;
  String selectedcine = "";
  late AnimationController animationController;
  late Animation<double> sizeAnimation;
  LatLng? myPosition;
  String? selectedcines;
  final PageController _pageController = PageController();

  // Método para cargar cines al iniciar
  Future<void> loadCines() async {
    try {
      final cines = await provider.getAll();
      setState(() {
        local = cines;
      });
    } catch (e) {
      // Maneja el error de carga de cines
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    sizeAnimation = Tween<double>(
      begin: 30.0,
      end: 60.0,
    ).animate(animationController);
    animationController.repeat(reverse: true);
    getCurrentLocation();
    loadCines(); // Cargar cines al iniciar
    super.initState();
  }

  Future<void> saveCine(Cines cine) async {
    try {
      final newCineId = await provider.save(cine);
      // Actualiza la lista local con el nuevo cine
      final newCine = Cines(
        nombre: newCineId,
        latitud: (null) ?? cine.latitud,
        longitud: (null) ?? cine.longitud,
        resenas: (null) ?? cine.resenas,
        peliculaProyectandose: (null) ?? cine.peliculaProyectandose,
        horainicio: (null) ?? cine.horainicio,
        imagen: (null) ?? cine.imagen,
        horarios: (null) ?? cine.horarios,
      );
      setState(() {
        local.add(newCine);
      });
    } catch (e) {
      // Maneja el error de guardado del cine
    }
  }

  void showSearchDialog() {
    // Implementa la lógica de búsqueda de cines
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void showDetails(String selectedCine) {
    setState(() {
      selectedcine = selectedCine;
      showCineDetails = true;
    });
  }

  void hideDetails() {
    setState(() {
      showCineDetails = false;
    });
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
      print(myPosition);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    prefs.ultimapagina = LoginScreen.nombre;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido ${prefs.usuario}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController nombreController = TextEditingController();
                  TextEditingController latitudController = TextEditingController();
                  TextEditingController longitudController = TextEditingController();
                  TextEditingController resenasController = TextEditingController();
                  TextEditingController peliculaProyectandoseController = TextEditingController();
                  TextEditingController horainicioController = TextEditingController();
                  TextEditingController imagenController = TextEditingController();
                  TextEditingController horariosController = TextEditingController();

                  return AlertDialog(
                    title: Text('Agregar Cine'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nombreController,
                          decoration: InputDecoration(labelText: 'Nombre del Cine'),
                        ),
                        TextField(
                          controller: latitudController,
                          decoration: InputDecoration(labelText: 'Latitud'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: longitudController,
                          decoration: InputDecoration(labelText: 'Longitud'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: resenasController,
                          decoration: InputDecoration(labelText: 'Reseñas'),
                        ),
                        TextField(
                          controller: peliculaProyectandoseController,
                          decoration: InputDecoration(labelText: 'Película Proyectándose'),
                        ),
                        TextField(
                          controller: horainicioController,
                          decoration: InputDecoration(labelText: 'Hora de Inicio'),
                        ),
                        TextField(
                          controller: imagenController,
                          decoration: InputDecoration(labelText: 'Imagen (URL)'),
                        ),
                        TextField(
                          controller: horariosController,
                          decoration: InputDecoration(labelText: 'Horarios'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String nombre = nombreController.text;
                          double latitud = double.tryParse(latitudController.text) ?? 0.0;
                          double longitud = double.tryParse(longitudController.text) ?? 0.0;
                          List<String> resenas = resenasController.text.split(',');
                          String peliculaProyectandose = peliculaProyectandoseController.text;
                          String horainicio = horainicioController.text;
                          String imagen = imagenController.text;
                          String horarios = horariosController.text;

                          if (nombre.isNotEmpty && latitud != 0.0 && longitud != 0.0) {
                            saveCine(Cines(
                              nombre: nombre,
                              latitud: latitud,
                              longitud: longitud,
                              resenas: resenas,
                              peliculaProyectandose: peliculaProyectandose,
                              horainicio: horainicio,
                              imagen: imagen,
                              horarios: horarios,
                            ));
                            Navigator.of(context).pop();
                          } else {
                            // Manejar el caso en el que no se proporcionan todos los datos necesarios
                          }
                        },
                        child: Text('Agregar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          DropdownButtonFormField<String>(
            value: selectedcines,
            onChanged: (newValue) {
              setState(() {
                selectedcines = newValue;
              });
            },
            items: ['Todos los Cines', ...getUniquenombre(local)]
                .map((nombre1) {
              return DropdownMenuItem(
                value: nombre1,
                child: Text(nombre1),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: "Seek",
              filled: true,
              fillColor: Color.fromARGB(255, 255, 255, 255),
            ),
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 16.0,
            ),
          )
        ],
      )),
      body: myPosition == null
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          center: myPosition!,
                          minZoom: 5,
                          maxZoom: 35,
                          zoom: 15,
                        ),
                        nonRotatedChildren: [
                          TileLayer(
                            urlTemplate:
                                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                            additionalOptions: const {
                              'accessToken': MAPBOX_ACCESS_TOKEN,
                              'id': 'mapbox/streets-v11'
                            },
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                height: 80,
                                width: 80,
                                point: myPosition!,
                                builder: (BuildContext context) {
                                  return AnimatedBuilder(
                                    animation: sizeAnimation,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Center(
                                        child: Image.asset(
                                          "assets/images/marker2.png",
                                          width: sizeAnimation.value,
                                          height: sizeAnimation.value,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              ...getFilteredlocal(local, selectedcines)
                                  .map((local) {
                                return Marker(
                                  height: 50,
                                  width: 50,
                                  point:
                                      LatLng(local.latitud, local.longitud),
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        print(local);
                                        setState(() {
                                          showCineDetails = true;
                                          selectedcine = local.nombre;
                                        });
                                      },
                                      child: AnimatedBuilder(
                                        animation: sizeAnimation,
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return Center(
                                            child: Image.asset(
                                              "assets/images/tienda.png",
                                              width: sizeAnimation.value,
                                              height: sizeAnimation.value,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                      if (showCineDetails)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return _MapItemDetails(
                                  selectedcine: selectedcine);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  List<String> getUniquenombre(List<Cines> local) {
    return local.map((local) => local.nombre).toSet().toList();
  }

  List<Cines> getFilteredlocal(
      List<Cines> local, String? selectednombre) {
    if (selectednombre == 'Todos los cines' || selectednombre == null) {
      return local;
    } else {
      return local
          .where((local) => local.nombre == selectednombre)
          .toList();
    }
  }
}

List<Cines> local = [
  Cines(
    nombre: 'Cine Colombia',
    latitud: 10.907399090308166,
    longitud: -74.80040072594659,
    resenas: ['Buen hambiente y excelente calidad', 'Gran servicio'],
    horarios: 'Lun-Vie: 10 AM - 10 PM',
    imagen: "assets/images/CC.png",
    peliculaProyectandose: '',
    horainicio: '',
  ),
  Cines(
    nombre: 'Royal Films',
    latitud: 10.989675364643436,
    longitud: -74.78810475177276,
    resenas: ['Buenos pasabocas', 'Excelente servicio'],
    horarios: 'Lun-Vie: 10 AM - 10 PM',
    imagen: "assets/images/royal-films.png",
    peliculaProyectandose: '',
    horainicio: '',
  ),
];

class _MapItemDetails extends StatelessWidget {
  final String selectedcine;

  const _MapItemDetails({required this.selectedcine});
  @override
  Widget build(BuildContext context) {
    final locales = local.firstWhere(
        (locales) => locales.nombre == selectedcine,
        orElse: () => Cines(
              nombre: '',
              latitud: 0.0,
              longitud: 0.0,
              resenas: [],
              peliculaProyectandose: '',
              horainicio: '',
              imagen: "",
              horarios: '',
            ));

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    margin: const EdgeInsets.only(top: 20.0),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Image.network(
                      locales.imagen, // Utiliza la URL de la imagen
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            locales.nombre,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text(
                            'Reseñas: ${locales.resenas.join(", ")}',
                            style: const TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        Text(
                          'Promociones: ${locales.peliculaProyectandose}',
                          style: const TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Text(
                          'Horarios: ${locales.horainicio}',
                          style: const TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 10.0, right: 10.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp1()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                          ),
                          icon: const Icon(
                            Icons.movie_creation_outlined,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          label: const Text(
                            'Ver cartelera',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: MaterialButton(
                          onPressed: () {},
                          color: Colors.black,
                          shape: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.notifications,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}