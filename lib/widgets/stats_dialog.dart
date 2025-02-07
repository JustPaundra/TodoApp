import 'package:flutter/material.dart';
import '../models/todo.dart';

class StatsDialog extends StatelessWidget {
  final List<Todo> todos;

  const StatsDialog({
    super.key,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    final completedTodos = todos.where((todo) => todo.isCompleted).toList();
    final overdueTodos = todos.where((todo) => todo.isOverdue).toList();

    final avgCompletionTime = completedTodos.isEmpty
        ? Duration.zero
        : completedTodos
        .map((todo) => todo.completionTime!)
        .reduce((a, b) => a + b) ~/ completedTodos.length;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _buildStatItem(
              context,
              Icons.task_outlined,
              'Total Tasks',
              todos.length.toString(),
            ),
            _buildStatItem(
              context,
              Icons.check_circle_outline,
              'Completed',
              completedTodos.length.toString(),
            ),
            _buildStatItem(
              context,
              Icons.warning_outlined,
              'Overdue',
              overdueTodos.length.toString(),
            ),
            _buildStatItem(
              context,
              Icons.timer_outlined,
              'Average Completion Time',
              '${avgCompletionTime.inHours}h ${avgCompletionTime.inMinutes % 60}m',
            ),
            _buildStatItem(
              context,
              Icons.percent_outlined,
              'Completion Rate',
              '${(completedTodos.length / todos.length * 100).toStringAsFixed(1)}%',
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      IconData icon,
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}