import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesApp {
  static late SharedPreferences sharedPreferences;

  static Future<SharedPreferences> init() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  static Future<bool> setArray({
    required String key,
    required List<String> array,
  }) async =>
      await sharedPreferences.setStringList(key, array);

  static List<String>? getArray({
    required String key,
  }) =>
      sharedPreferences.getStringList(key);

  static Future<bool> remove({
    required String key,
  }) async =>
      await sharedPreferences.remove(key);

  static Future<void> updateItem({
    required String key,
    required int index,
    required String newValue,
  }) async {
    List<String>? array = sharedPreferences.getStringList(key);
    if (array != null && index >= 0 && index < array.length) {
      array[index] = newValue;
      await sharedPreferences.setStringList(key, array);
    }
  }

  static Future<void> deleteItem({
    required String key,
    required int index,
  }) async {
    List<String>? array = sharedPreferences.getStringList(key);
    if (array != null && index >= 0 && index < array.length) {
      array.removeAt(index);
      await sharedPreferences.setStringList(key, array);
    }
  }
}


