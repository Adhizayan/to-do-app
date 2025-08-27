import 'package:uuid/uuid.dart';

enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { pending, inProgress, completed, cancelled }

class Task {
  final String id;
  String title;
  String description;
  DateTime? dueDate;
  DateTime? startTime;
  DateTime? endTime;
  TaskPriority priority;
  TaskStatus status;
  String? categoryId;
  List<String> tags;
  int estimatedDuration; // in minutes
  int actualDuration; // in minutes
  bool isRecurring;
  String? recurrenceRule;
  DateTime createdAt;
  DateTime updatedAt;
  String? notes;
  List<String> subtasks;
  int completedSubtasks;
  String? timeBlockId;
  int? colorValue;
  bool isArchived;
  List<String> attachments;
  double? completionPercentage;

  Task({
    String? id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.startTime,
    this.endTime,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.categoryId,
    List<String>? tags,
    this.estimatedDuration = 30,
    this.actualDuration = 0,
    this.isRecurring = false,
    this.recurrenceRule,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.notes,
    List<String>? subtasks,
    this.completedSubtasks = 0,
    this.timeBlockId,
    this.colorValue,
    this.isArchived = false,
    List<String>? attachments,
    this.completionPercentage = 0.0,
  })  : id = id ?? const Uuid().v4(),
        tags = tags ?? [],
        subtasks = subtasks ?? [],
        attachments = attachments ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert Task to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'priority': priority.index,
      'status': status.index,
      'categoryId': categoryId,
      'tags': tags,
      'estimatedDuration': estimatedDuration,
      'actualDuration': actualDuration,
      'isRecurring': isRecurring,
      'recurrenceRule': recurrenceRule,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
      'subtasks': subtasks,
      'completedSubtasks': completedSubtasks,
      'timeBlockId': timeBlockId,
      'colorValue': colorValue,
      'isArchived': isArchived,
      'attachments': attachments,
      'completionPercentage': completionPercentage,
    };
  }

  // Create Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      priority: TaskPriority.values[map['priority'] ?? 1],
      status: TaskStatus.values[map['status'] ?? 0],
      categoryId: map['categoryId'],
      tags: List<String>.from(map['tags'] ?? []),
      estimatedDuration: map['estimatedDuration'] ?? 30,
      actualDuration: map['actualDuration'] ?? 0,
      isRecurring: map['isRecurring'] ?? false,
      recurrenceRule: map['recurrenceRule'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      notes: map['notes'],
      subtasks: List<String>.from(map['subtasks'] ?? []),
      completedSubtasks: map['completedSubtasks'] ?? 0,
      timeBlockId: map['timeBlockId'],
      colorValue: map['colorValue'],
      isArchived: map['isArchived'] ?? false,
      attachments: List<String>.from(map['attachments'] ?? []),
      completionPercentage: (map['completionPercentage'] ?? 0.0).toDouble(),
    );
  }

  // Copy with method for updating task
  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? startTime,
    DateTime? endTime,
    TaskPriority? priority,
    TaskStatus? status,
    String? categoryId,
    List<String>? tags,
    int? estimatedDuration,
    int? actualDuration,
    bool? isRecurring,
    String? recurrenceRule,
    String? notes,
    List<String>? subtasks,
    int? completedSubtasks,
    String? timeBlockId,
    int? colorValue,
    bool? isArchived,
    List<String>? attachments,
    double? completionPercentage,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      notes: notes ?? this.notes,
      subtasks: subtasks ?? this.subtasks,
      completedSubtasks: completedSubtasks ?? this.completedSubtasks,
      timeBlockId: timeBlockId ?? this.timeBlockId,
      colorValue: colorValue ?? this.colorValue,
      isArchived: isArchived ?? this.isArchived,
      attachments: attachments ?? this.attachments,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && status != TaskStatus.completed;
  }

  bool get isToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  bool get isTomorrow {
    if (dueDate == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dueDate!.year == tomorrow.year &&
        dueDate!.month == tomorrow.month &&
        dueDate!.day == tomorrow.day;
  }

  bool get isThisWeek {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return dueDate!.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
        dueDate!.isBefore(endOfWeek.add(const Duration(days: 1)));
  }
}
