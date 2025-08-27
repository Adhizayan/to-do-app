import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/time_block.dart';
import '../models/task.dart';

class AddTimeBlockScreen extends StatefulWidget {
  const AddTimeBlockScreen({Key? key}) : super(key: key);

  @override
  State<AddTimeBlockScreen> createState() => _AddTimeBlockScreenState();
}

class _AddTimeBlockScreenState extends State<AddTimeBlockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  Color _color = Colors.blue;
  bool _isFlexible = false;
  String? _linkedTaskId;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Block'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Date
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(DateFormat('EEE, MMM d, yyyy').format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 12),

            // Start / End time
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickStartTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(_startTime.format(context)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickEndTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(_endTime.format(context)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Link to task
            DropdownButtonFormField<String>(
              value: _linkedTaskId,
              decoration: const InputDecoration(
                labelText: 'Link to Task (optional)',
                prefixIcon: Icon(Icons.link),
              ),
              items: provider.tasks
                  .where((t) => t.status != TaskStatus.completed)
                  .map((t) => DropdownMenuItem(
                        value: t.id,
                        child: Text(t.title, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _linkedTaskId = value),
            ),
            const SizedBox(height: 16),

            // Color picker quick choices
            Wrap(
              spacing: 8,
              children: [
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.teal,
              ].map((c) => GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: c,
                      child: _color == c
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  ))
                .toList(),
            ),
            const SizedBox(height: 12),

            SwitchListTile(
              value: _isFlexible,
              onChanged: (v) => setState(() => _isFlexible = v),
              title: const Text('Flexible block (allow overlaps)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Time Block'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(context: context, initialTime: _startTime);
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(context: context, initialTime: _endTime);
    if (picked != null) setState(() => _endTime = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<TaskProvider>(context, listen: false);

    final start = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final end = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    final block = TimeBlock(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: start,
      endTime: end,
      color: _color,
      isFlexible: _isFlexible,
      taskId: _linkedTaskId,
    );

    try {
      await provider.addTimeBlock(block);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Time block added')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

