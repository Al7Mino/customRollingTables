import 'package:flutter/material.dart';

class StringAddDialogForm extends StatefulWidget {
  const StringAddDialogForm({
    super.key,
    this.onValidate,
    this.onCancel,
  });

  final void Function(String)? onValidate;
  final void Function()? onCancel;

  @override
  State<StringAddDialogForm> createState() => _StringAddDialogFormState();
}

class _StringAddDialogFormState extends State<StringAddDialogForm> {
  final controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: controller,
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                widget.onValidate?.call(controller.text);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                widget.onCancel?.call();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}

class StringAddDialog {
  static Future<void> builder(
    BuildContext context, [
    void Function(String)? onValidate,
    void Function()? onCancel,
  ]) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            StringAddDialogForm(
              onValidate: onValidate,
              onCancel: onCancel,
            ),
          ],
        );
      },
    );
  }
}
