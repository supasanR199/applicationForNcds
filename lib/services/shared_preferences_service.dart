import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createCache(String name, dynamic value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    _preferences.setString(name, value);
  }

  Future readCache(String name) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    var cache = _preferences.getString(name);
    return cache;
  }

  Future removeCache(String name) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    _preferences.remove(name);
  }
}
