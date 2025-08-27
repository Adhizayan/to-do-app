import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/time_block.dart';
import '../widgets/time_block_card.dart';

class TimeBlockScreen extends StatefulWidget {
  const TimeBlockScreen({Key? key}) : super(key: key);

  @override
  State<TimeBlockScreen> createState() => _TimeBlockScreenState();
}

class _TimeBlockScreenState extends State<TimeBlockScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Blocks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTimeBlockDialog(context),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          provider.setSelectedDate(_selectedDay);
          final dayBlocks = provider.selectedDateTimeBlocks;

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: dayBlocks.isEmpty
                    ? _buildEmptyState()
                    : _buildTimeBlocksList(dayBlocks, provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No time blocks scheduled',
            style: TextStyle(fontSize: 18, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _showAddTimeBlockDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Time Block'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBlocksList(List<TimeBlock> blocks, TaskProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        final block = blocks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TimeBlockCard(
            timeBlock: block,
            onTap: () => _showTimeBlockDetails(context, block, provider),
            onComplete: () => provider.toggleTimeBlockCompletion(block.id),
            onDelete: () => _confirmDelete(context, block, provider),
          ),
        );
      },
    );
  }

  void _showAddTimeBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Time Block'),
        content: const Text('Time block creation will be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTimeBlockDetails(BuildContext context, TimeBlock block, TaskProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              block.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('HH:mm').format(block.startTime)} - ${DateFormat('HH:mm').format(block.endTime)}',
                ),
              ],
            ),
            if (block.description != null) ...[
              const SizedBox(height: 16),
              Text(block.description!),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    provider.toggleTimeBlockCompletion(block.id);
                    Navigator.pop(context);
                  },
                  icon: Icon(block.isCompleted ? Icons.undo : Icons.check),
                  label: Text(block.isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmDelete(context, block, provider);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TimeBlock block, TaskProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Time Block'),
        content: Text('Are you sure you want to delete "${block.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTimeBlock(block.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
