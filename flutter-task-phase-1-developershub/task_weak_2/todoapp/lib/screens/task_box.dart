import 'package:flutter/material.dart';

class TaskBox extends StatelessWidget {
  final String taskName;
  final VoidCallback onDelete;

  const TaskBox({super.key, required this.taskName, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),

              Text(taskName, style: const TextStyle(fontSize: 18)),
            ],
          ),

           IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,)
        ],
      ),
    );
  }
}
