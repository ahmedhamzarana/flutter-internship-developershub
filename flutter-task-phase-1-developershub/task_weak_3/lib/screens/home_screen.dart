import 'package:flutter/material.dart';
import 'package:task_weak_3/components/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, String>> tasks = [
    {"title": "Team Meeting", "time": "9:30 AM", "status": "Completed"},
    {"title": "Design Review", "time": "11:00 AM", "status": "Pending"},
    {"title": "Client Call", "time": "1:30 PM", "status": "Completed"},
    {"title": "Submit Report", "time": "3:00 PM", "status": "Pending"},
    {"title": "Project Planning", "time": "4:30 PM", "status": "Completed"},
    {"title": "Daily Standup", "time": "6:00 PM", "status": "Pending"},
    {"title": "Daily Standup", "time": "6:00 PM", "status": "Pending"},
  ];

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        centerTitle: true,
        title: const Text(
          "Task Management App",
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            /// Header
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Hi, Ahmed 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Tasks Grid
            Expanded(
              child: GridView.builder(
                itemCount: tasks.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {

                  final task = tasks[index];

                  return TaskCard(
                    title: task["title"]!,
                    time: task["time"]!,
                    status: task["status"]!,

                    onEdit: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Edit feature coming soon"),
                        ),
                      );
                    },

                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Task"),
                          content: const Text(
                              "Are you sure you want to delete this task?"),
                          actions: [

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),

                            TextButton(
                              onPressed: () {
                                deleteTask(index);
                                Navigator.pop(context);
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Add Task feature coming soon"),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}