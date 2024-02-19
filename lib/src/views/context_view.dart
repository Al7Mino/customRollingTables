import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rolling_tables/src/controllers/data_controller.dart';
import 'package:rolling_tables/src/models/context_model.dart';
import 'package:rolling_tables/src/models/table_model.dart';
import 'package:rolling_tables/src/widgets/string_add_dialog.dart';

class ContextView extends StatefulWidget {
  const ContextView({
    super.key,
    required this.contextName,
    required this.dataController,
  });

  final String? contextName;
  final DataController dataController;

  @override
  State<ContextView> createState() => _ContextViewState();
}

class _ContextViewState extends State<ContextView> {
  void onValidate(String value) {
    if (widget.contextName == null) {
      return;
    }
    final newTable = TableModel(value);
    widget.dataController.addTable(widget.contextName!, newTable);
    Navigator.pop(context);
  }

  void onCancel() {
    Navigator.pop(context);
  }

  void onRemoveTable(TableModel value) {
    if (widget.contextName == null) {
      return;
    }
    widget.dataController.removeTable(widget.contextName!, value);
  }

  @override
  Widget build(BuildContext context) {
    final ContextModel contextModel = widget.dataController.dataModel.contexts
        .firstWhere((element) => element.name == widget.contextName);

    return ListenableBuilder(
      listenable: widget.dataController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(contextModel.name),
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
                  tooltip: 'Add a new table',
                  onPressed: () {
                    StringAddDialog.builder(context, onValidate, onCancel);
                  }),
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
            itemCount: contextModel.tables.length,
            itemBuilder: (BuildContext context, int index) {
              final item = contextModel.tables[index];

              return ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      onRemoveTable(item);
                    },
                  ),
                  onTap: () {
                    context.go('/context/${widget.contextName}/${item.name}');
                  });
            },
          ),
        );
      },
    );
  }
}
