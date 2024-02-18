import 'package:flutter/material.dart';
import 'package:rolling_tables/src/models/data_model.dart';

import '../services/data_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class DataController with ChangeNotifier {
  DataController(this._dataService);

  // Make DataService a private variable so it is not used directly.
  final DataService _dataService;

  // Make DataModel a private variable so it is not updated directly without
  // also persisting the changes with the DataService.
  late DataModel _dataModel = DataModel();

  // Allow Widgets to read the user's preferred ThemeMode.
  DataModel get dataModel => _dataModel;

  /// Load the user's data from the DataService.
  Future<void> loadData() async {
    _dataModel = await _dataService.getData();
    notifyListeners();
  }

  /// Update and persist the DataModel.
  Future<void> updateData(DataModel? newDataModel) async {
    if (newDataModel == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newDataModel == _dataModel) return;

    // Otherwise, store the new ThemeMode in memory
    _dataModel = newDataModel;

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(newDataModel);
  }

  Future<void> addContext(String? newContext) async {
    if (newContext == null) return;
    _dataModel.contexts.add(newContext);

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }

  Future<void> removeContext(String? value) async {
    if (value == null) return;
    _dataModel.contexts.remove(value);

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }
}
