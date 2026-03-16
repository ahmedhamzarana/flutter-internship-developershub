import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../models/task_model.dart';
import '../../utils/app_routes.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// TaskScreen - Screen for adding or editing tasks
class TaskScreen extends StatefulWidget {
  final String? taskId;
  final TaskModel? existingTask;

  const TaskScreen({
    super.key,
    this.taskId,
    this.existingTask,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskStatus _selectedStatus = TaskStatus.pending;

  bool _isSubmitting = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.existingTask != null;
    
    if (_isEditMode && widget.existingTask != null) {
      _loadExistingTask(widget.existingTask!);
    }
  }

  void _loadExistingTask(TaskModel task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _selectedDate = task.dueDate;
    _selectedTime = TimeOfDay.fromDateTime(task.dueTime);
    _selectedPriority = task.priority;
    _selectedStatus = task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      title: Text(
        _isEditMode ? 'Edit Task' : 'Add New Task',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => NavigationHelper.goBack(context),
      ),
      actions: _isEditMode
          ? [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: _handleDelete,
                tooltip: 'Delete task',
              ),
            ]
          : null,
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Field
            CustomTextField(
              label: 'Task Title *',
              hint: 'Enter task title',
              controller: _titleController,
              validator: FormValidators.validateTitle,
              prefixIcon: const Icon(Icons.title),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Description Field
            CustomTextField(
              label: 'Description',
              hint: 'Enter task description (optional)',
              controller: _descriptionController,
              validator: FormValidators.validateDescription,
              prefixIcon: const Icon(Icons.description),
              maxLines: 4,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Date Picker
            _buildDatePicker(),
            const SizedBox(height: AppSpacing.lg),

            // Time Picker
            _buildTimePicker(),
            const SizedBox(height: AppSpacing.lg),

            // Priority Selector
            _buildPrioritySelector(),
            const SizedBox(height: AppSpacing.lg),

            // Status Selector (only for edit mode)
            if (_isEditMode) _buildStatusSelector(),
            const SizedBox(height: AppSpacing.xl),

            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Due Date',
          prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: _pickTime,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Due Time',
          prefixIcon: const Icon(Icons.access_time, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedTime.format(context),
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPriorityOption(
              priority: TaskPriority.low,
              color: AppColors.priorityLow,
            ),
            const SizedBox(width: AppSpacing.md),
            _buildPriorityOption(
              priority: TaskPriority.medium,
              color: AppColors.priorityMedium,
            ),
            const SizedBox(width: AppSpacing.md),
            _buildPriorityOption(
              priority: TaskPriority.high,
              color: AppColors.priorityHigh,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityOption({
    required TaskPriority priority,
    required Color color,
  }) {
    final isSelected = _selectedPriority == priority;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPriority = priority;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.2) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                priority.displayName,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return CustomDropdown<TaskStatus>(
      label: 'Status',
      value: _selectedStatus,
      items: TaskStatus.values,
      itemToString: (status) => status.displayName,
      onChanged: (value) {
        setState(() {
          _selectedStatus = value;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: _isEditMode ? 'Update Task' : 'Create Task',
      onPressed: _isSubmitting ? null : _handleSubmit,
      isLoading: _isSubmitting,
      fullWidth: true,
      size: ButtonSize.large,
      icon: _isEditMode ? Icons.update : Icons.add_task,
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      // Combine date and time
      final dueDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      bool success;

      if (_isEditMode && widget.existingTask != null) {
        // Update existing task
        final updatedTask = widget.existingTask!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _selectedDate,
          dueTime: dueDateTime,
          priority: _selectedPriority,
          status: _selectedStatus,
          updatedAt: DateTime.now(),
        );

        success = await taskProvider.updateTask(updatedTask);
      } else {
        // Create new task
        success = await taskProvider.addTask(
          userId: authProvider.userId!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _selectedDate,
          dueTime: dueDateTime,
          priority: _selectedPriority,
        );
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode ? 'Task updated successfully!' : 'Task created successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        NavigationHelper.goBack(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Operation failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Delete',
            variant: ButtonVariant.danger,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        final success = await taskProvider.deleteTask(widget.taskId!);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          NavigationHelper.goBack(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }
}
