import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rolling_tables/src/controllers/table_controller.dart';
import 'package:rolling_tables/src/models/table_model.dart';
import 'package:rolling_tables/src/widgets/string_add_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.tableController});

  final TableController tableController;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    widget.tableController.loadTables();
    setState(() {
      loading = false;
    });
  }

  void onValidate(String value) {
    final newTable = TableModel(name: value);
    widget.tableController.addTable(newTable);
    Navigator.pop(context);
  }

  void onCancel() {
    Navigator.pop(context);
  }

  void onRemoveTable(TableModel value) {
    if (value.id == null) {
      return;
    }
    widget.tableController.deleteTable(value.id!);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.tableController,
      builder: (context, child) {
        if (loading) {
          return const CircularProgressIndicator();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Tables list'),
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
                tooltip: 'Add a new table',
                onPressed: () {
                  StringAddDialog.builder(context, onValidate, onCancel);
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  context.go('/settings');
                },
              ),
            ],
          ),
          // To work with lists that may contain a large number of items, it’s best
          // to use the ListView.builder constructor.
          //
          // In contrast to the default ListView constructor, which requires
          // building all Widgets up front, the ListView.builder constructor lazily
          // builds Widgets as they’re scrolled into view.
          body: ListView.builder(
            // Providing a restorationId allows the ListView to restore the
            // scroll position when a user leaves and returns to the app after it
            // has been killed while running in the background.
            restorationId: 'homeView',
            itemCount: widget.tableController.tables.length,
            itemBuilder: (BuildContext context, int index) {
              final item = widget.tableController.tables[index];

              return ListTile(
                title: Text(item.name),
                trailing: IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    onRemoveTable(item);
                  },
                ),
                onTap: () {
                  context.go('/tables/${item.name}');
                },
              );
            },
          ),
        );
      },
    );
  }
}
