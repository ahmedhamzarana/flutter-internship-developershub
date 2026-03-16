import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

/// TaskProvider - Manages tasks state using Provider pattern
/// Notifies widgets when tasks change with real-time updates
class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  // List of all tasks
  List<TaskModel> _tasks = [];

  // Loading state
  bool _isLoading = false;

  // Error message
  String? _errorMessage;

  // Stream subscription for real-time updates
  StreamSubscription<List<TaskModel>>? _tasksSubscription;

  // Current filter
  TaskFilter _currentFilter = TaskFilter.all;

  // Search query
  String _searchQuery = '';

  // Getters
  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TaskFilter get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  /// Get filtered tasks based on current filter and search
  List<TaskModel> get filteredTasks {
    var filtered = _tasks;

    // Apply status filter
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

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  /// Get pending tasks count
  int get pendingCount {
    return _tasks.where((t) => t.status == TaskStatus.pending).length;
  }

  /// Get completed tasks count
  int get completedCount {
    return _tasks.where((t) => t.status == TaskStatus.completed).length;
  }

  /// Get overdue tasks count
  int get overdueCount {
    return _tasks.where((t) => t.isOverdue && t.status == TaskStatus.pending).length;
  }

  /// Initialize tasks listener for a user
  void initialize(String userId) {
    _isLoading = true;
    _notifySafely();

    // Cancel previous subscription if exists
    _tasksSubscription?.cancel();

    // Listen to real-time updates
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

  /// Set filter
  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    _notifySafely();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _notifySafely();
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    _notifySafely();
  }

  /// Refresh tasks
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

  /// Add a new task
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

      // Create task model with UUID
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

      // Add to Firebase
      await _taskService.addTask(task ,userId);
      // Real-time stream will update automatically

      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add task: $e';
      _notifySafely();
      return false;
    }
  }

  /// Update an existing task
  Future<bool> updateTask(TaskModel task) async {
    try {
      _errorMessage = null;
      await _taskService.updateTask(task);
      // Real-time stream will update automatically
      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update task: $e';
      _notifySafely();
      return false;
    }
  }

  /// Delete a task
  Future<bool> deleteTask(String taskId) async {
    try {
      _errorMessage = null;
      await _taskService.deleteTask(taskId);
      // Real-time stream will update automatically
      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete task: $e';
      _notifySafely();
      return false;
    }
  }

  /// Toggle task status
  Future<bool> toggleTaskStatus(String taskId, TaskStatus newStatus) async {
    try {
      _errorMessage = null;
      await _taskService.updateTaskStatus(taskId, newStatus);
      // Real-time stream will update automatically
      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update task: $e';
      _notifySafely();
      return false;
    }
  }

  /// Update task priority
  Future<bool> updateTaskPriority(String taskId, TaskPriority priority) async {
    try {
      _errorMessage = null;
      await _taskService.updateTaskPriority(taskId, priority);
      // Real-time stream will update automatically
      _notifySafely();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update task priority: $e';
      _notifySafely();
      return false;
    }
  }

  /// Mark task as complete
  Future<bool> markAsComplete(String taskId) async {
    return toggleTaskStatus(taskId, TaskStatus.completed);
  }

  /// Mark task as pending
  Future<bool> markAsPending(String taskId) async {
    return toggleTaskStatus(taskId, TaskStatus.pending);
  }

  /// Mark task as in progress
  Future<bool> markAsInProgress(String taskId) async {
    return toggleTaskStatus(taskId, TaskStatus.inProgress);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    _notifySafely();
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }

  /// Private helper to notify listeners safely during build
  void _notifySafely() {
    // Use Future.microtask to ensure we're out of build phase
    Future.microtask(() {
      notifyListeners();
    });
  }
}

/// Task Filter Enum
enum TaskFilter {
  all,
  pending,
  inProgress,
  completed,
  overdue,
}

/// Extension for display name
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
