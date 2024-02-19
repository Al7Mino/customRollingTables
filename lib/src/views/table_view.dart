import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rolling_tables/custom_icons.dart';
import 'package:rolling_tables/src/controllers/data_controller.dart';
import 'package:rolling_tables/src/models/context_model.dart';
import 'package:rolling_tables/src/models/table_entry_model.dart';
import 'package:rolling_tables/src/models/table_model.dart';
import 'package:rolling_tables/src/widgets/string_add_dialog.dart';

class TableView extends StatefulWidget {
  const TableView({
    super.key,
    required this.contextName,
    required this.tableName,
    required this.dataController,
  });

  final String? contextName;
  final String? tableName;
  final DataController dataController;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  void onValidate(String value) {
    if (widget.contextName == null || widget.tableName == null) {
      return;
    }
    final newEntry = TableEntryModel(value);
    widget.dataController.addEntry(
      widget.contextName!,
      widget.tableName!,
      newEntry,
    );
    Navigator.pop(context);
  }

  void onCancel() {
    Navigator.pop(context);
  }

  void onRemoveEntry(TableEntryModel value) {
    if (widget.contextName == null || widget.tableName == null) {
      return;
    }
    widget.dataController.removeEntry(
      widget.contextName!,
      widget.tableName!,
      value,
    );
  }

  void onRollAll() {
    final ContextModel contextModel = widget.dataController.dataModel.contexts
        .firstWhere((element) => element.name == widget.contextName);
    final TableModel tableModel = contextModel.tables
        .firstWhere((element) => element.name == widget.tableName);

    List<int> scores = [];
    for (var i = 0; i < tableModel.entries.length; i++) {
      var res = Random().nextInt(20) + 1;
      scores.add(res);
    }
    widget.dataController.updateEntriesScore(
      widget.contextName!,
      widget.tableName!,
      scores,
    );
  }

  void onRoll(TableEntryModel entry) {
    var score = Random().nextInt(20) + 1;
    widget.dataController.updateEntryScore(
      widget.contextName!,
      widget.tableName!,
      entry.name,
      score,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.1);

    final ContextModel contextModel = widget.dataController.dataModel.contexts
        .firstWhere((element) => element.name == widget.contextName);
    final TableModel tableModel = contextModel.tables
        .firstWhere((element) => element.name == widget.tableName);

    return ListenableBuilder(
      listenable: widget.dataController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(tableModel.name),
            actions: [
              IconButton(
                  icon: const Icon(Icons.upload),
                  tooltip: 'Import contexts',
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.download),
                  tooltip: 'Download contexts',
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add a new entry',
                  onPressed: () {
                    StringAddDialog.builder(context, onValidate, onCancel);
                  }),
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
          body: ListView.builder(
            restorationId: 'contextView',
            itemCount: tableModel.entries.length,
            itemBuilder: (BuildContext context, int index) {
              final item = tableModel.entries[index];

              return ListTile(
                tileColor: index.isOdd ? oddItemColor : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name),
                    Text(item.score.toString()),
                  ],
                ),
                trailing: SizedBox(
                  width: 100,
                  height: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(CustomIcons.dice),
                        onPressed: () {
                          onRoll(item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          onRemoveEntry(item);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
