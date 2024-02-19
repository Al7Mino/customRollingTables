import 'package:flutter/material.dart';
import 'package:rolling_tables/src/models/context_model.dart';
import 'package:rolling_tables/src/models/data_model.dart';
import 'package:rolling_tables/src/models/table_entry_model.dart';
import 'package:rolling_tables/src/models/table_model.dart';

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

  // Allow Widgets to read the user's data.
  DataModel get dataModel => _dataModel;

  /// Load the user's data from the DataService.
  Future<void> loadData() async {
    _dataModel = await _dataService.getData();
    notifyListeners();
  }

  /// Update and persist the DataModel.
  Future<void> updateData(DataModel? newDataModel) async {
    if (newDataModel == null) return;

    // Do not perform any work if new and old DataModel are identical
    if (newDataModel == _dataModel) return;

    // Otherwise, store the new DataModel in memory
    _dataModel = newDataModel;

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(newDataModel);
  }

  /// Add a Context to the DataModel
  Future<void> addContext(ContextModel? newContext) async {
    if (newContext == null) return;
    _dataModel.addContext(newContext);

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }

  /// Remove a Context from the DataModel
  Future<void> removeContext(ContextModel? value) async {
    if (value == null) return;
    _dataModel.removeContext(value);

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }

  /// Add a Table in a specific context
  Future<void> addTable(String contextName, TableModel? newTable) async {
    if (newTable == null) return;
    final context = _dataModel.contexts
        .firstWhere((element) => element.name == contextName);
    context.addTable(newTable);

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }

  /// Remove a Table from a specific context
  Future<void> removeTable(String contextName, TableModel? newTable) async {
    if (newTable == null) return;
    final context = _dataModel.contexts
        .firstWhere((element) => element.name == contextName);
    context.removeTable(newTable);

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }

  /// Add a TableEntry in a specific table from a specific context
  Future<void> addEntry(
      String contextName, String tableName, TableEntryModel? newEntry) async {
    if (newEntry == null) return;
    final context = _dataModel.contexts
        .firstWhere((element) => element.name == contextName);
    final table =
        context.tables.firstWhere((element) => element.name == tableName);
    table.addTableEntry(newEntry);

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }

  /// Remove a TableEntry from a specific table in a specific context
  Future<void> removeEntry(
      String contextName, String tableName, TableEntryModel? newEntry) async {
    if (newEntry == null) return;
    final context = _dataModel.contexts
        .firstWhere((element) => element.name == contextName);
    final table =
        context.tables.firstWhere((element) => element.name == tableName);
    table.removeTableEntry(newEntry);

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }

  /// Update a TableEntry score in a specific Table from a specific Context
  Future<void> updateEntryScore(
    String contextName,
    String tableName,
    String entryName,
    int score,
  ) async {
    final context = _dataModel.contexts
        .firstWhere((element) => element.name == contextName);
    final table =
        context.tables.firstWhere((element) => element.name == tableName);
    final entry =
        table.entries.firstWhere((element) => element.name == entryName);
    entry.score = score;

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }

  /// Update all TableEntry score in a specific Table from a specific Context
  Future<void> updateEntriesScore(
    String contextName,
    String tableName,
    List<int> scores,
  ) async {
    final context = _dataModel.contexts
        .firstWhere((element) => element.name == contextName);
    final table =
        context.tables.firstWhere((element) => element.name == tableName);
    if (table.entries.length != scores.length) {
      return;
    }
    for (var i = 0; i < scores.length; i++) {
      table.entries[i].score = scores[i];
    }

    notifyListeners();

    // Persist the changes.
    await _dataService.updateData(_dataModel);
  }
}
