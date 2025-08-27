import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../utils/theme.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TaskPriority _priority = TaskPriority.medium;
  String? _selectedCategoryId;
  int _estimatedDuration = 30;
  List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        actions: [
          TextButton(
            onPressed: _saveTask,
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
                labelText: 'Task Title',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            
            // Category Selection
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
              items: provider.categories.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Row(
                    children: [
                      Icon(category.icon, size: 20, color: category.color),
                      const SizedBox(width: 8),
                      Text(category.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Priority Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Priority', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: TaskPriority.values.map((priority) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(_getPriorityText(priority)),
                          selected: _priority == priority,
                          selectedColor: AppTheme.getPriorityColor(priority.index).withOpacity(0.3),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _priority = priority;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Date and Time
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                            : 'Select date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _selectTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Select time',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Estimated Duration
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimated Duration: $_estimatedDuration minutes'),
                Slider(
                  value: _estimatedDuration.toDouble(),
                  min: 15,
                  max: 240,
                  divisions: 15,
                  label: '$_estimatedDuration min',
                  onChanged: (value) {
                    setState(() {
                      _estimatedDuration = value.toInt();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Tags
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tags', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        decoration: const InputDecoration(
                          hintText: 'Add tag',
                          isDense: true,
                        ),
                        onSubmitted: _addTag,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _addTag(_tagController.text),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                if (_tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        onDeleted: () {
                          setState(() {
                            _tags.remove(tag);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save),
              label: const Text('Save Task'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
        _tagController.clear();
      });
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      
      DateTime? dueDateTime;
      if (_selectedDate != null) {
        if (_selectedTime != null) {
          dueDateTime = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          );
        } else {
          dueDateTime = _selectedDate;
        }
      }
      
      final task = Task(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: dueDateTime,
        priority: _priority,
        categoryId: _selectedCategoryId,
        estimatedDuration: _estimatedDuration,
        tags: _tags,
      );
      
      await provider.addTask(task);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully')),
        );
      }
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }
}
