import 'package:shared_preferences/shared_preferences.dart';
import 'settings/game_constants.dart';
import 'settings/game_path.dart';

class StorageData {

  static late SharedPreferences _sharedPreferences;

  static get getSharedPreferences => _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    GamePath.setPath(getStorageStringFieldData(gameFolderPathKey) ?? '');
  }

  static bool? getStorageBoolFieldData(String fieldName) {
    return _sharedPreferences.getBool(fieldName);
  }

  static void setStorageBoolFieldData(String fieldName, bool value) {
    _sharedPreferences.setBool(fieldName, value);
  }

  static String? getStorageStringFieldData(String fieldName) {
    return _sharedPreferences.getString(fieldName);
  }

  static void setStorageStringFieldData(String fieldName, String value) {
    _sharedPreferences.setString(fieldName, value);
  }
}