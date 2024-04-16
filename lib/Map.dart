import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prueba/Cartelera.dart';
import 'package:prueba/Login.dart';

import 'Sharepreference/Sharepreference.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGFuaWVsanIxMSIsImEiOiJjbG5lcXhiYTgwZThhMmpvNGtlNG1vcTdxIn0.xLcplNW4L11ON3Ekf3wpaQ';

class MapScreen extends StatefulWidget {
  static const String nombre = 'mapa';

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final prefs = PreferenciaUsuario();

  final PageController _pageController = PageController();
  bool showCineDetails = false;
  String selectedcine = "";
  //animations marker
  late AnimationController animationController;
  late Animation<double> sizeAnimation;
  LatLng? myPosition;
  String? selectedcines; // Categoría seleccionada

  // Función para mostrar el cuadro de diálogo de búsqueda de cines
  void showSearchDialog() {
    // Aquí puedes implementar la lógica para mostrar el cuadro de diálogo de búsqueda
    // o navegar a otra pantalla para agregar nuevas ubicaciones de cines.
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

  void showDetails(String selectedcine) {
    setState(() {
      selectedcine = selectedcine;
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
  void initState() {
    //initialization
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    sizeAnimation = Tween<double>(
      begin: 30.0,
      end: 60.0,
    ).animate(animationController);
    animationController.repeat(reverse: true);
    print(animationController);
//animationController.forward();
    getCurrentLocation();
    super.initState();
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
            icon: Icon(Icons.search),
            onPressed: () {
              // Función para mostrar el cuadro de diálogo de búsqueda
              showSearchDialog();
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

class Cines {
  final String nombre;
  final double latitud;
  final double longitud;
  final List<String> resenas;
  final String peliculaProyectandose;
  final String horainicio;
  final String imagen;

  Cines({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.resenas,
    required this.peliculaProyectandose,
    required this.horainicio,
    required this.imagen,
    required String horarios,
  });
}

final List<Cines> local = [
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
                      width: 150.0,
                      height: 150.0,
                      margin: const EdgeInsets.only(top: 20.0),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Image.asset(
                        locales.imagen,
                      )),
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