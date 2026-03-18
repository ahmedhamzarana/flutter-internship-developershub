import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();

  factory TaskService() {
    return _instance;
  }

  TaskService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _tasksCollection = 'tasks';

  Future<String> addTask(TaskModel task, String userId) async {
    try {
      final docRef = await _firestore.collection(_tasksCollection).add({
        ...task.toMap(),
        'userId': userId,
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  Future<TaskModel?> getTask(String taskId) async {
    try {
      final doc = await _firestore.collection(_tasksCollection).doc(taskId).get();
      if (doc.exists) {
        return TaskModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  Future<List<TaskModel>> getUserTasks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_tasksCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('dueDate', descending: true)
          .orderBy('dueTime', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  Stream<List<TaskModel>> getTasksStream(String userId) {
    return _firestore
        .collection(_tasksCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate', descending: true)
        .orderBy('dueTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<TaskModel>> getPendingTasksStream(String userId) {
    return _firestore
        .collection(_tasksCollection)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: TaskStatus.pending.name)
        .orderBy('dueDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<TaskModel>> getCompletedTasksStream(String userId) {
    return _firestore
        .collection(_tasksCollection)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: TaskStatus.completed.name)
        .orderBy('dueDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _firestore
          .collection(_tasksCollection)
          .doc(task.id)
          .update(task.copyWith(updatedAt: DateTime.now()).toMap());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection(_tasksCollection).doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      await _firestore.collection(_tasksCollection).doc(taskId).update({
        'status': status.name,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }

  Future<void> updateTaskPriority(String taskId, TaskPriority priority) async {
    try {
      await _firestore.collection(_tasksCollection).doc(taskId).update({
        'priority': priority.name,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update task priority: $e');
    }
  }

  Future<Map<String, int>> getTaskCounts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_tasksCollection)
          .where('userId', isEqualTo: userId)
          .get();

      int total = snapshot.docs.length;
      int pending = snapshot.docs.where((doc) =>
        doc.data()['status'] == TaskStatus.pending.name).length;
      int completed = snapshot.docs.where((doc) =>
        doc.data()['status'] == TaskStatus.completed.name).length;
      int inProgress = snapshot.docs.where((doc) =>
        doc.data()['status'] == TaskStatus.inProgress.name).length;

      return {
        'total': total,
        'pending': pending,
        'completed': completed,
        'inProgress': inProgress,
      };
    } catch (e) {
      throw Exception('Failed to get task counts: $e');
    }
  }

  Stream<List<TaskModel>> searchTasks(String userId, String query) {
    if (query.isEmpty) {
      return getTasksStream(userId);
    }

    return _firestore
        .collection(_tasksCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
          .where((task) =>
            task.title.toLowerCase().contains(query.toLowerCase()) ||
            task.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
