import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/time_block.dart';

class TimeBlockCard extends StatelessWidget {
  final TimeBlock timeBlock;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;

  const TimeBlockCard({
    Key? key,
    required this.timeBlock,
    this.onTap,
    this.onComplete,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: timeBlock.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: timeBlock.color.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    timeBlock.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: timeBlock.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 18,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: timeBlock.color),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('HH:mm').format(timeBlock.startTime)} - ${DateFormat('HH:mm').format(timeBlock.endTime)}',
                  style: TextStyle(color: timeBlock.color),
                ),
              ],
            ),
            if (timeBlock.description != null && timeBlock.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                timeBlock.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: timeBlock.isCompleted
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    timeBlock.isCompleted ? 'Completed' : 'Scheduled',
                    style: TextStyle(
                      fontSize: 12,
                      color: timeBlock.isCompleted ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onComplete != null)
                  TextButton.icon(
                    onPressed: onComplete,
                    icon: Icon(
                      timeBlock.isCompleted ? Icons.undo : Icons.check,
                      size: 16,
                    ),
                    label: Text(timeBlock.isCompleted ? 'Undo' : 'Done'),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

