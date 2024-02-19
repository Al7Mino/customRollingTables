import 'dart:convert';

import 'package:rolling_tables/src/models/data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves data.
class DataService {
  /// Loads data from local storage.
  Future<DataModel> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('data');
    if (dataString == null) {
      return DataModel();
    }
    final json = jsonDecode(dataString);
    final dataModel = DataModel.fromJson(json);
    return dataModel;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateData(DataModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final json = data.toJson();
    final dataString = jsonEncode(json);
    await prefs.setString('data', dataString);
  }
}
