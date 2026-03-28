import 'package:flutter/material.dart';
import 'package:rolling_tables/src/models/table_model.dart';

import '../services/tables_service.dart';

class TableController with ChangeNotifier {
  TableController(this._tableService);

  // Make SettingsService a private variable so it is not used directly.
  final TableService _tableService;

  List<TableModel> _tables = [];

  List<TableModel> get tables => List.unmodifiable(_tables);

  Future<void> loadTables() async {
    _tables = await _tableService.getAll();

    notifyListeners();
  }

  Future<TableModel> getTable(String name) async {
    final table = await _tableService.findByName(name);
    notifyListeners();

    return table;
  }

  Future<TableModel?> addTable(TableModel newTable) async {
    final created = await _tableService.create(newTable);
    _tables.add(created);
    notifyListeners();

    return created;
  }

  Future<void> renameTable(int tableId, String newName) async {
    if (newName.trim().isEmpty) {
      return;
    }
    final index = _tables.indexWhere((t) => t.id == tableId);
    if (index == -1) {
      return;
    }
    final updatedTable = _tables[index].copyWith(name: newName);
    _tables[index] = updatedTable;
    notifyListeners();
    await _tableService.update(updatedTable);
  }

  Future<void> deleteTable(int tableId) async {
    await _tableService.delete(tableId);
    _tables.removeWhere((t) => t.id == tableId);
    notifyListeners();
  }
}
