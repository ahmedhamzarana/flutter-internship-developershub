import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

/// TaskService - Handles all Firebase Firestore operations for tasks
class TaskService {
  // Singleton instance
  static final TaskService _instance = TaskService._internal();
  
  factory TaskService() {
    return _instance;
  }
  
  TaskService._internal();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection name
  static const String _tasksCollection = 'tasks';

  /// Add a new task
  /// Returns the task ID if successful
Future<String> addTask(TaskModel task, String userId) async {
  try {
    final docRef = await _firestore.collection(_tasksCollection).add({
      ...task.toMap(),
      'userId': userId,  // Ye line zaroori hai
    });
    return docRef.id;
  } catch (e) {
    throw Exception('Failed to add task: $e');
  }
}
  /// Get a single task by ID
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

  /// Get all tasks for a user
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

  /// Get real-time stream of user tasks
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

  /// Get pending tasks stream
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

  /// Get completed tasks stream
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

  /// Update a task
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

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection(_tasksCollection).doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  /// Update task status
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

  /// Update task priority
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

  /// Get task count by status
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

  /// Search tasks by title
  Stream<List<TaskModel>> searchTasks(String userId, String query) {
    if (query.isEmpty) {
      return getTasksStream(userId);
    }

    // Note: For production, use Algolia or ElasticSearch for better search
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
