import 'package:flutter/material.dart';
import 'package:todoapp/model/task_model.dart';
import 'package:todoapp/screens/custom_dailog.dart';
import 'package:todoapp/screens/task_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskModel taskModel = TaskModel();
  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await taskModel.fetchTask();
    setState(() {});
  }

  void deleteTask(int index) async {
    await taskModel.deleteTask(index);
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Todo App"),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskBox(
              taskName: tasks[index],
              onDelete: () => deleteTask(index),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDailog(
                onSave: (task) {
                  taskModel.addTask(task);
                  loadTasks();
                },
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
