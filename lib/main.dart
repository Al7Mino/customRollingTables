import 'package:flutter/material.dart';
import 'src/controllers/option_item_controller.dart';
import 'src/database/database_helper.dart';
import 'src/services/option_item_service.dart';
import 'src/services/tables_service.dart';
import 'src/controllers/table_controller.dart';

import 'src/app.dart';
import 'src/controllers/settings_controller.dart';
import 'src/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  final settingsController = SettingsController(SettingsService());
  final tableController = TableController(TableService());
  final optionItemController = OptionItemController(OptionItemService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
    settingsController: settingsController,
    tableController: tableController,
    optionItemController: optionItemController,
  ));
}
