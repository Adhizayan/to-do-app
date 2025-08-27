import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/task.dart';
import '../utils/theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onStatusToggle;
  final VoidCallback? onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onStatusToggle,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (onStatusToggle != null)
            SlidableAction(
              onPressed: (_) => onStatusToggle!(),
              backgroundColor: task.status == TaskStatus.completed
                  ? Colors.orange
                  : Colors.green,
              foregroundColor: Colors.white,
              icon: task.status == TaskStatus.completed
                  ? Icons.undo
                  : Icons.check,
              label: task.status == TaskStatus.completed ? 'Undo' : 'Done',
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (_) => onDelete!(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
        ],
      ),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Checkbox
                if (onStatusToggle != null)
                  InkWell(
                    onTap: onStatusToggle,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: task.status == TaskStatus.completed
                              ? Colors.green
                              : Colors.grey,
                          width: 2,
                        ),
                        color: task.status == TaskStatus.completed
                            ? Colors.green
                            : Colors.transparent,
                      ),
                      child: task.status == TaskStatus.completed
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                if (onStatusToggle != null) const SizedBox(width: 12),
                
                // Task Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Priority Indicator
                          Container(
                            width: 4,
                            height: 20,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.getPriorityColor(task.priority.index),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          
                          // Task Title
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: task.status == TaskStatus.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.status == TaskStatus.completed
                                    ? Colors.grey
                                    : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            decoration: task.status == TaskStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      
                      const SizedBox(height: 8),
                      
                      // Tags and Date Row
                      Row(
                        children: [
                          // Due Date
                          if (task.dueDate != null) ...[
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: task.isOverdue ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(task.dueDate!),
                              style: TextStyle(
                                fontSize: 12,
                                color: task.isOverdue ? Colors.red : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          
                          // Duration
                          if (task.estimatedDuration > 0) ...[
                            const Icon(
                              Icons.timer,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${task.estimatedDuration}m',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          
                          // Tags
                          if (task.tags.isNotEmpty)
                            Expanded(
                              child: Wrap(
                                spacing: 4,
                                children: task.tags.take(2).map((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow';
    } else if (taskDate.isBefore(today)) {
      return 'Overdue';
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }
}
