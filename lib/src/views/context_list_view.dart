import 'package:flutter/material.dart';
import 'package:rolling_tables/src/controllers/data_controller.dart';
import 'package:rolling_tables/src/services/data_service.dart';
import 'package:rolling_tables/src/widgets/string_add_dialog.dart';

import '../settings/settings_view.dart';

class ContextListView extends StatefulWidget {
  const ContextListView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<ContextListView> createState() => _ContextListViewState();
}

class _ContextListViewState extends State<ContextListView> {
  bool loading = false;

  final DataController dataController = DataController(DataService());

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    dataController.loadData();
    setState(() {
      loading = false;
    });
  }

  void onValidate(String value) {
    dataController.addContext(value);
    Navigator.pop(context);
  }

  void onCancel() {
    Navigator.pop(context);
  }

  void onRemoveContext(String name) {
    dataController.removeContext(name);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: dataController,
      builder: (context, child) {
        if (loading) {
          return const CircularProgressIndicator();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Context List'),
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
                  tooltip: 'Add a new context',
                  onPressed: () {
                    StringAddDialog.builder(context, onValidate, onCancel);
                  }),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Navigate to the settings page. If the user leaves and returns
                  // to the app after it has been killed while running in the
                  // background, the navigation stack is restored.
                  Navigator.restorablePushNamed(
                      context, SettingsView.routeName);
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
            restorationId: 'contextListView',
            itemCount: dataController.dataModel.contexts.length,
            itemBuilder: (BuildContext context, int index) {
              final item = dataController.dataModel.contexts[index];

              return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      onRemoveContext(item);
                    },
                  ),
                  onTap: () {
                    // Navigate to the details page. If the user leaves and returns to
                    // the app after it has been killed while running in the
                    // background, the navigation stack is restored.
                    /* Navigator.restorablePushNamed(
                    context,
                    SampleItemDetailsView.routeName,
                  ); */
                  });
            },
          ),
        );
      },
    );
  }
}
