import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TaskModel {

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _key = "tasks";

  Future<List<String>> fetchTask() async {
    String? data = await _storage.read(key: _key);

    if (data == null) {
      return [];
    }

    List list = jsonDecode(data);
    return List<String>.from(list);
  }

  Future<void> addTask(String task) async {
    List<String> tasks = await fetchTask();

    tasks.add(task);

    await _storage.write(
      key: _key,
      value: jsonEncode(tasks),
    );
  }

  Future<void> deleteTask(int index) async {
    List<String> tasks = await fetchTask();

    tasks.removeAt(index);

    await _storage.write(
      key: _key,
      value: jsonEncode(tasks),
    );
  }
}