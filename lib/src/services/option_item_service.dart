import '../models/option_item_model.dart';

import '../database/database_helper.dart';

class OptionItemService {
  final DatabaseHelper _dbHelper;

  OptionItemService({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  /// Get all option items from the table with id `tableId`.
  Future<List<OptionItemModel>> getAll(int tableId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'options',
      where: 'table_id = ?',
      whereArgs: [tableId],
    );
    return rows.map(OptionItemModel.fromMap).toList();
  }

  /// Add a new option item and return entity with its generated id.
  Future<OptionItemModel> create(OptionItemModel item) async {
    final db = await _dbHelper.database;
    final id = await db.insert('options', item.toMap());
    return item.copyWith(id: id);
  }

  /// Update an existing option item.
  Future<void> update(OptionItemModel item) async {
    final db = await _dbHelper.database;
    await db.update(
      'options',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  /// Update `sort_order` from all option items in one transaction.
  Future<void> updateSortOrders(List<OptionItemModel> options) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (int i = 0; i < options.length; i++) {
      batch.update(
        'options',
        {'sort_order': i},
        where: 'id = ?',
        whereArgs: [options[i].id],
      );
    }
    await batch.commit(noResult: true);
  }

  /// Delete an option item, given its id.
  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete('options', where: 'id = ?', whereArgs: [id]);
  }
}
