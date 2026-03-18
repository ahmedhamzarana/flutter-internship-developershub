import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<TaskModel>>? _tasksSubscription;
  TaskFilter _currentFilter = TaskFilter.all;
  String _searchQuery = '';

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TaskFilter get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  List<TaskModel> get filteredTasks {
    var filtered = _tasks;

    switch (_currentFilter) {
      case TaskFilter.all:
        break;
      case TaskFilter.pending:
        filtered = filtered.where((t) => t.status == TaskStatus.pending).toList();
        break;
      case TaskFilter.inProgress:
        filtered = filtered.where((t) => t.status == TaskStatus.inProgress).toList();
        break;
      case TaskFilter.completed:
        filtered = filtered.where((t) => t.status == TaskStatus.completed).toList();
        break;
      case TaskFilter.overdue:
        filtered = filtered.where((t) => t.isOverdue).toList();
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  int get pendingCount {
    return _tasks.where((t) => t.status == TaskStatus.pending).length;
  }

  int get completedCount {
    return _tasks.where((t) => t.status == TaskStatus.completed).length;
  }

  int get overdueCount {
    return _tasks.where((t) => t.isOverdue && t.status == TaskStatus.pending).length;
  }

  void initialize(String userId) {
    _isLoading = true;
    _notifySafely();

    _tasksSubscription?.cancel();

    _tasksSubscription = _taskService.getTasksStream(userId).listen(
      (tasks) {
        _tasks = tasks;
        _isLoading = false;
        _errorMessage = null;
        _notifySafely();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = 'Failed to load tasks: $error';
        _notifySafely();
      },
    );
  }

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    _notifySafely();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _notifySafely();
  }

  void clearSearch() {
    _searchQuery = '';
    _notifySafely();
  }

  Future<void> refreshTasks(String userId) async {
    try {
      _isLoading = true;
      _notifySafely();

      _tasks = await _taskService.getUserTasks(userId);
      _errorMessage = null;
      _isLoading = false;
      _notifySafely();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to refresh tasks: $e';
      _notifySafely();
    }
  }

  Future<bool> addTask({
    required String userId,
    required String title,
    String description = '',
    required DateTime dueDate,
    required DateTime dueTime,
    TaskPriority priority = TaskPriority.medium,
  }) async {
    try {
      _errorMessage = null;

      final task = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        userId: userId,
        dueDate: dueDate,
        dueTime: dueTime,
        priority: priority,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      );

      await _taskService.addTask(task ,userId);

      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add task: $e';
      _notifySafely();
      return false;
    }
  }

  Future<bool> updateTask(TaskModel task) async {
    try {
      _errorMessage = null;
      await _taskService.updateTask(task);
      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update task: $e';
      _notifySafely();
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      _errorMessage = null;
      await _taskService.deleteTask(taskId);
      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete task: $e';
      _notifySafely();
      return false;
    }
  }

  Future<bool> toggleTaskStatus(String taskId, TaskStatus newStatus) async {
    try {
      _errorMessage = null;
      await _taskService.updateTaskStatus(taskId, newStatus);
      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update task: $e';
      _notifySafely();
      return false;
    }
  }

  Future<bool> updateTaskPriority(String taskId, TaskPriority priority) async {
    try {
      _errorMessage = null;
      await _taskService.updateTaskPriority(taskId, priority);
      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update task priority: $e';
      _notifySafely();
      return false;
    }
  }

  Future<bool> markAsComplete(String taskId) async {
    return toggleTaskStatus(taskId, TaskStatus.completed);
  }

  Future<bool> markAsPending(String taskId) async {
    return toggleTaskStatus(taskId, TaskStatus.pending);
  }

  Future<bool> markAsInProgress(String taskId) async {
    return toggleTaskStatus(taskId, TaskStatus.inProgress);
  }

  void clearError() {
    _errorMessage = null;
    _notifySafely();
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }

  void _notifySafely() {
    Future.microtask(() {
      notifyListeners();
    });
  }
}

enum TaskFilter {
  all,
  pending,
  inProgress,
  completed,
  overdue,
}

extension TaskFilterExtension on TaskFilter {
  String get displayName {
    switch (this) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.pending:
        return 'Pending';
      case TaskFilter.inProgress:
        return 'In Progress';
      case TaskFilter.completed:
        return 'Completed';
      case TaskFilter.overdue:
        return 'Overdue';
    }
  }
}
