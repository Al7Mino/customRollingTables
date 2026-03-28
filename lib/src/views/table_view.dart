import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rolling_tables/custom_icons.dart';
import 'package:rolling_tables/src/controllers/option_item_controller.dart';
import 'package:rolling_tables/src/controllers/table_controller.dart';
import 'package:rolling_tables/src/models/option_item_model.dart';
import 'package:rolling_tables/src/models/table_model.dart';
import 'package:rolling_tables/src/views/option_view.dart';
import 'package:rolling_tables/src/widgets/string_add_dialog.dart';

class TableView extends StatefulWidget {
  const TableView({
    super.key,
    required this.tableName,
    required this.tableController,
    required this.optionItemController,
  });

  final String? tableName;
  final TableController tableController;
  final OptionItemController optionItemController;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  bool loading = false;
  TableModel? table;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    var tab = await widget.tableController.getTable(widget.tableName!);
    setState(() {
      loading = true;
      table = tab;
    });
    widget.optionItemController.loadOptionItems(tab.id!);
    setState(() {
      loading = false;
    });
  }

  void onValidate(String value) {
    if (table?.id == null) {
      return;
    }
    final newEntry = OptionItemModel(tableId: table!.id!, name: value);
    widget.optionItemController.addOptionItem(newEntry);
    Navigator.pop(context);
  }

  void onCancel() {
    Navigator.pop(context);
  }

  void onRemoveOptionItem(OptionItemModel value) {
    if (value.id == null) {
      return;
    }
    widget.optionItemController.deleteOptionItem(value.id!);
  }

  void onRollAll() {
    final Iterable<OptionItemModel> options = widget
        .optionItemController
        .options
        .where((option) => !option.isLocked);

    for (var i = 0; i < options.length; i++) {
      var res = Random().nextInt(20) + 1;
      widget.optionItemController.updateScore(options.elementAt(i).id!, res);
    }
  }

  void onUpdate(OptionItemModel newItem) {
    if (newItem.id == null) {
      return;
    }
    widget.optionItemController.updateOptionItem(
      newItem.id!,
      name: newItem.name,
      score: newItem.score,
      isLocked: newItem.isLocked,
      sortOrder: newItem.sortOrder,
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    widget.optionItemController.reorder(oldIndex, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.optionItemController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(table?.name ?? ""),
            actions: [
              IconButton(
                icon: const Icon(Icons.upload),
                tooltip: 'Import contexts',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: 'Download contexts',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add a new entry',
                onPressed: () {
                  StringAddDialog.builder(context, onValidate, onCancel);
                },
              ),
              IconButton(
                icon: const Icon(CustomIcons.dice),
                tooltip: 'Roll all entries',
                onPressed: onRollAll,
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  context.go('/settings');
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Text(
                  '${widget.optionItemController.options.length} entrées',
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: ReorderableListView.builder(
                    restorationId: 'tableView',
                    onReorder: onReorder,
                    proxyDecorator: (child, index, animation) => Material(
                      color: Colors.transparent,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(16),
                      child: child,
                    ),
                    itemCount: widget.optionItemController.options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = widget.optionItemController.options[index];
                      return OptionView(
                        key: ValueKey(item.id),
                        option: item,
                        index: index,
                        onUpdate: onUpdate,
                        onDelete: () => onRemoveOptionItem(item),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
