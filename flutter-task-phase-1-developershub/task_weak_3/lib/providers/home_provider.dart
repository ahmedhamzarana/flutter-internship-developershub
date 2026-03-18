import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {

  List<Map<String, String>> tasks = [
    {"title": "Team Meeting", "time": "9:30 AM", "status": "Completed"},
    {"title": "Design Review", "time": "11:00 AM", "status": "Pending"},
    {"title": "Client Call", "time": "1:30 PM", "status": "Completed"},
    {"title": "Submit Report", "time": "3:00 PM", "status": "Pending"},
    {"title": "Project Planning", "time": "4:30 PM", "status": "Completed"},
    {"title": "Daily Standup", "time": "6:00 PM", "status": "Pending"},
  ];

  void deleteTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  void addTask() {
    tasks.add({
      "title": "New Task",
      "time": "7:00 PM",
      "status": "Pending"
    });

    notifyListeners();
  }
}
