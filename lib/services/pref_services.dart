import 'package:shared_preferences/shared_preferences.dart';

abstract class prefServ {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance()
        .whenComplete(() => print('prefs config success'));
  }
}
