import 'package:shared_preferences/shared_preferences.dart';

class PreferenciaUsuario {
  static final PreferenciaUsuario _instancia = PreferenciaUsuario._internal();

  factory PreferenciaUsuario() {
    return _instancia;
  }

  PreferenciaUsuario._internal();

  late SharedPreferences _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? _usuario;
  String? _contrasena;

  Future<void> saveUserData(String username, String password) async {
    await _prefs.setString('username', username);
    await _prefs.setString('password', password);
    _usuario = username;
    _contrasena = password;
  }

  Future<void> loadUserData() async {
    _usuario = _prefs.getString('username');
    _contrasena = _prefs.getString('password');
  }

  String get usuario => _usuario ?? "usuario no encontrado";

  set usuario(String value) {
    _usuario = value;
    _prefs.setString('usuario', value);
  }

  String get contrasena => _contrasena ?? "contrasena incorrecta";

  set contrasena(String value) {
    _contrasena = value;
    _prefs.setString('contrasena', value);
  }

  String get ultimapagina {
    return _prefs.getString('ultimapagina') ?? 'home';
  }

  set ultimapagina(String value) {
    _prefs.setString('ultimapagina', value);
  }
}