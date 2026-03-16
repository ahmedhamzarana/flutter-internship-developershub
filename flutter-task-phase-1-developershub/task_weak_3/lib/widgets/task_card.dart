import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

/// TaskCard - Displays a single task with all its details
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(TaskStatus)? onStatusChange;
  final bool showActions;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStatusChange,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = task.status == TaskStatus.completed;
    final isOverdue = task.isOverdue && !isCompleted;

    return Card(
      elevation: 2,
      shadowColor: isOverdue 
          ? Colors.red.withValues(alpha: 0.3) 
          : Colors.grey.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isOverdue
                ? LinearGradient(
                    colors: [
                      Colors.red.shade50,
                      Colors.orange.shade50,
                    ],
                  )
                : isCompleted
                    ? LinearGradient(
                        colors: [
                          Colors.green.shade50,
                          Colors.teal.shade50,
                        ],
                      )
                    : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Priority badge + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPriorityBadge(theme),
                  _buildStatusChip(theme, isCompleted),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                task.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted 
                      ? Colors.grey 
                      : isOverdue 
                          ? Colors.red.shade700 
                          : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),

              // Description (if exists)
              if (task.description.isNotEmpty)
                Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),

              // Date and Time
              Row(
                children: [
                  _buildDateTimeChip(
                    icon: Icons.calendar_today,
                    text: DateFormat('MMM dd, yyyy').format(task.dueDate),
                    color: isOverdue ? Colors.red : Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildDateTimeChip(
                    icon: Icons.access_time,
                    text: DateFormat('hh:mm a').format(task.dueTime),
                    color: isOverdue ? Colors.red : Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Actions
              if (showActions) _buildActions(context, isCompleted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(ThemeData theme) {
    Color color;
    String text;

    switch (task.priority) {
      case TaskPriority.high:
        color = Colors.red;
        text = 'High';
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        text = 'Medium';
        break;
      case TaskPriority.low:
        color = Colors.green;
        text = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, bool isCompleted) {
    Color color;
    IconData icon;

    if (isCompleted) {
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (task.isOverdue) {
      color = Colors.red;
      icon = Icons.warning;
    } else {
      color = Colors.blue;
      icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            task.status.displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isCompleted) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Status toggle button
        if (onStatusChange != null)
          IconButton(
            onPressed: () => onStatusChange!(
              isCompleted ? TaskStatus.pending : TaskStatus.completed,
            ),
            icon: Icon(
              isCompleted ? Icons.undo : Icons.check_circle_outline,
            ),
            color: isCompleted ? Colors.orange : Colors.green,
            tooltip: isCompleted ? 'Mark as pending' : 'Mark as complete',
          ),
        
        // Edit button
        if (onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            color: theme.colorScheme.primary,
            tooltip: 'Edit task',
          ),
        
        // Delete button
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            color: Colors.red,
            tooltip: 'Delete task',
          ),
      ],
    );
  }
}
