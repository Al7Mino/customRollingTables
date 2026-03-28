import '../database/database_helper.dart';
import '../models/table_model.dart';

class TableService {
  final DatabaseHelper _dbHelper;

  TableService({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  /// Get all tables.
  Future<List<TableModel>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query('tables');
    return rows.map(TableModel.fromMap).toList();
  }

  /// Find table from name.
  Future<TableModel> findByName(String name) async {
    final db = await _dbHelper.database;
    final rows = await db.query('tables', where: 'name = ?', whereArgs: [name]);
    return TableModel.fromMap(rows.first);
  }

  /// Add a new table and return entity with its generated id.
  Future<TableModel> create(TableModel table) async {
    final db = await _dbHelper.database;
    final id = await db.insert('tables', table.toMap());
    return table.copyWith(id: id);
  }

  /// Update an existing table.
  Future<void> update(TableModel table) async {
    final db = await _dbHelper.database;
    await db.update(
      'tables',
      table.toMap(),
      where: 'id = ?',
      whereArgs: [table.id],
    );
  }

  /// Delete a table, given its id.
  /// Associated options will be deleted on cascade.
  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete('tables', where: 'id = ?', whereArgs: [id]);
  }
}
