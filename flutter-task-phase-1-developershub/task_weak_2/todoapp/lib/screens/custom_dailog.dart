import 'package:flutter/material.dart';

class CustomDailog extends StatefulWidget {
  final Function(String) onSave;
  const CustomDailog({super.key, required this.onSave});

  @override
  State<CustomDailog> createState() => _CustomDailogState();
}

class _CustomDailogState extends State<CustomDailog> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController addTaskController = TextEditingController();
    return AlertDialog(
      title: const Text("Add Task"),

      content: TextField(
        controller: addTaskController,
        decoration: const InputDecoration(
          hintText: "Enter your task",
          border: OutlineInputBorder(),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {
            widget.onSave(addTaskController.text);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
