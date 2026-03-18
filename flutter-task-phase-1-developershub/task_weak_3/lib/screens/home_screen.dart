import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../utils/app_routes.dart';
import '../../utils/constants.dart';
import '../../widgets/task_card.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/custom_button.dart';
import '../../models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeTasks() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (authProvider.userId != null) {
        taskProvider.initialize(authProvider.userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer2<AuthProvider, TaskProvider>(
        builder: (context, authProvider, taskProvider, child) {
          if (authProvider.isCheckingAuth || taskProvider.isLoading) {
            return const LoadingWidget(message: 'Loading tasks...');
          }

          if (taskProvider.errorMessage != null) {
            return ErrorStateWidget(
              message: taskProvider.errorMessage!,
              onRetry: () {
                taskProvider.clearError();
                _initializeTasks();
              },
            );
          }

          return _buildContent(taskProvider);
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      title: const Text(
        'My Tasks',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => _showSearchDialog(),
          tooltip: 'Search tasks',
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: _handleLogout,
          tooltip: 'Logout',
        ),
      ],
    );
  }

  Widget _buildContent(TaskProvider taskProvider) {
    if (taskProvider.tasks.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.task_alt,
        title: 'No Tasks Yet!',
        subtitle: 'Tap the + button to add your first task',
        onAction: () => _navigateToAddTask(),
        actionLabel: 'Add Task',
      );
    }

    return Column(
      children: [
        _buildStatsCards(taskProvider),
        _buildFilterChips(taskProvider),
        Expanded(
          child: _buildTaskList(taskProvider),
        ),
      ],
    );
  }

  Widget _buildStatsCards(TaskProvider taskProvider) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          _buildStatCard(
            icon: Icons.list,
            label: 'Total',
            count: taskProvider.tasks.length,
            color: AppColors.info,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildStatCard(
            icon: Icons.schedule,
            label: 'Pending',
            count: taskProvider.pendingCount,
            color: AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildStatCard(
            icon: Icons.check_circle,
            label: 'Done',
            count: taskProvider.completedCount,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(TaskProvider taskProvider) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          _buildFilterChip(
            label: 'All',
            filter: TaskFilter.all,
            currentFilter: taskProvider.currentFilter,
            onTap: () => taskProvider.setFilter(TaskFilter.all),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            label: 'Pending',
            filter: TaskFilter.pending,
            currentFilter: taskProvider.currentFilter,
            onTap: () => taskProvider.setFilter(TaskFilter.pending),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            label: 'In Progress',
            filter: TaskFilter.inProgress,
            currentFilter: taskProvider.currentFilter,
            onTap: () => taskProvider.setFilter(TaskFilter.inProgress),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            label: 'Completed',
            filter: TaskFilter.completed,
            currentFilter: taskProvider.currentFilter,
            onTap: () => taskProvider.setFilter(TaskFilter.completed),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            label: 'Overdue',
            filter: TaskFilter.overdue,
            currentFilter: taskProvider.currentFilter,
            onTap: () => taskProvider.setFilter(TaskFilter.overdue),
            showCount: taskProvider.overdueCount,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required TaskFilter filter,
    required TaskFilter currentFilter,
    required VoidCallback onTap,
    int? showCount,
  }) {
    final isSelected = currentFilter == filter;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (showCount != null && showCount > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                showCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildTaskList(TaskProvider taskProvider) {
    final tasks = taskProvider.filteredTasks;

    if (tasks.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No tasks found',
        subtitle: taskProvider.searchQuery.isNotEmpty
            ? 'Try a different search term'
            : 'No tasks match the current filter',
        onAction: taskProvider.searchQuery.isNotEmpty
            ? () {
                taskProvider.clearSearch();
                _searchController.clear();
              }
            : null,
        actionLabel: 'Clear Search',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onTap: () => _navigateToEditTask(task),
          onEdit: () => _navigateToEditTask(task),
          onDelete: () => _showDeleteDialog(task),
          onStatusChange: (status) => _handleStatusChange(task, status),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _navigateToAddTask,
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Add Task',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _navigateToAddTask() {
    Navigator.pushNamed(
      context,
      AppRoutes.task,
      arguments: {'taskId': null, 'existingTask': null},
    ).then((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (authProvider.userId != null) {
        taskProvider.refreshTasks(authProvider.userId!);
      }
    });
  }

  void _navigateToEditTask(TaskModel task) {
    Navigator.pushNamed(
      context,
      AppRoutes.task,
      arguments: {'taskId': task.id, 'existingTask': task},
    ).then((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (authProvider.userId != null) {
        taskProvider.refreshTasks(authProvider.userId!);
      }
    });
  }

  void _showDeleteDialog(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Delete',
            variant: ButtonVariant.danger,
            onPressed: () async {
              Navigator.pop(context);

              final taskProvider = Provider.of<TaskProvider>(context, listen: false);
              final success = await taskProvider.deleteTask(task.id);

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _handleStatusChange(TaskModel task, TaskStatus newStatus) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    await taskProvider.toggleTaskStatus(task.id, newStatus);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task marked as ${newStatus.displayName}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _showSearchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Search Tasks',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by title or description...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            final taskProvider = Provider.of<TaskProvider>(
                              context,
                              listen: false,
                            );
                            taskProvider.clearSearch();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  final taskProvider = Provider.of<TaskProvider>(
                    context,
                    listen: false,
                  );
                  taskProvider.setSearchQuery(value);
                },
                textInputAction: TextInputAction.search,
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomButton(
                text: 'Close',
                variant: ButtonVariant.outlined,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Logout',
            variant: ButtonVariant.danger,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();

      if (mounted) {
        NavigationHelper.goToLogin(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
