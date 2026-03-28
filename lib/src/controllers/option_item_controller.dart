import 'package:flutter/material.dart';

import '../models/option_item_model.dart';
import '../services/option_item_service.dart';

class OptionItemController with ChangeNotifier {
  OptionItemController(this._optionItemService);

  // Make SettingsService a private variable so it is not used directly.
  final OptionItemService _optionItemService;

  List<OptionItemModel> _options = [];

  List<OptionItemModel> get options => List.unmodifiable(_options);

  Future<void> loadOptionItems(int tableId) async {
    _options = await _optionItemService.getAll(tableId);

    notifyListeners();
  }

  Future<OptionItemModel?> addOptionItem(OptionItemModel newItem) async {
    final created = await _optionItemService.create(newItem);
    _options.add(created);
    notifyListeners();

    return created;
  }

  Future<void> updateOptionItem(
    int itemId, {
    String? name,
    int? score,
    bool? isLocked,
    int? sortOrder,
  }) async {
    final index = _options.indexWhere((o) => o.id == itemId);
    if (index == -1) {
      return;
    }
    final updatedOptionItem = _options[index].copyWith(
      name: name,
      score: score,
      isLocked: isLocked,
      sortOrder: sortOrder,
    );
    _options[index] = updatedOptionItem;
    notifyListeners();
    await _optionItemService.update(updatedOptionItem);
  }

  Future<void> renameOptionItem(int itemId, String newName) async {
    if (newName.trim().isEmpty) {
      return;
    }
    final index = _options.indexWhere((o) => o.id == itemId);
    if (index == -1) {
      return;
    }
    final updatedOptionItem = _options[index].copyWith(name: newName);
    _options[index] = updatedOptionItem;
    notifyListeners();
    await _optionItemService.update(updatedOptionItem);
  }

  Future<void> updateScore(int itemId, int newScore) async {
    final index = _options.indexWhere((o) => o.id == itemId);
    if (index == -1) {
      return;
    }
    final updatedOptionItem = _options[index].copyWith(score: newScore);
    _options[index] = updatedOptionItem;
    notifyListeners();
    await _optionItemService.update(updatedOptionItem);
  }

  Future<void> updateLock(int itemId, bool isLocked) async {
    final index = _options.indexWhere((o) => o.id == itemId);
    if (index == -1) {
      return;
    }
    final updatedOptionItem = _options[index].copyWith(isLocked: isLocked);
    _options[index] = updatedOptionItem;
    notifyListeners();
    await _optionItemService.update(updatedOptionItem);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex--;
    }
    final item = _options.removeAt(oldIndex);
    _options.insert(newIndex, item);
    notifyListeners();
    await _optionItemService.updateSortOrders(_options);
  }

  Future<void> deleteOptionItem(int itemId) async {
    await _optionItemService.delete(itemId);
    _options.removeWhere((o) => o.id == itemId);
    notifyListeners();
  }
}
