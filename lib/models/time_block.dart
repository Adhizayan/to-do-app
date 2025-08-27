import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TimeBlock {
  final String id;
  String title;
  String? taskId;
  DateTime startTime;
  DateTime endTime;
  Color color;
  String? description;
  bool isCompleted;
  bool isFlexible;
  String? categoryId;
  List<String> notifications;
  DateTime createdAt;
  DateTime updatedAt;
  String? recurrenceRule;
  bool isRecurring;
  String? location;
  List<String> participants;

  TimeBlock({
    String? id,
    required this.title,
    this.taskId,
    required this.startTime,
    required this.endTime,
    Color? color,
    this.description,
    this.isCompleted = false,
    this.isFlexible = false,
    this.categoryId,
    List<String>? notifications,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.recurrenceRule,
    this.isRecurring = false,
    this.location,
    List<String>? participants,
  })  : id = id ?? const Uuid().v4(),
        color = color ?? Colors.blue,
        notifications = notifications ?? [],
        participants = participants ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Duration of the time block
  Duration get duration => endTime.difference(startTime);

  // Check if time block is happening now
  bool get isHappeningNow {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  // Check if time block is in the past
  bool get isPast => endTime.isBefore(DateTime.now());

  // Check if time block is in the future
  bool get isFuture => startTime.isAfter(DateTime.now());

  // Check if time block is today
  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'taskId': taskId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'color': color.value,
      'description': description,
      'isCompleted': isCompleted,
      'isFlexible': isFlexible,
      'categoryId': categoryId,
      'notifications': notifications,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'recurrenceRule': recurrenceRule,
      'isRecurring': isRecurring,
      'location': location,
      'participants': participants,
    };
  }

  // Create from Map
  factory TimeBlock.fromMap(Map<String, dynamic> map) {
    return TimeBlock(
      id: map['id'],
      title: map['title'],
      taskId: map['taskId'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      color: Color(map['color'] ?? Colors.blue.value),
      description: map['description'],
      isCompleted: map['isCompleted'] ?? false,
      isFlexible: map['isFlexible'] ?? false,
      categoryId: map['categoryId'],
      notifications: List<String>.from(map['notifications'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      recurrenceRule: map['recurrenceRule'],
      isRecurring: map['isRecurring'] ?? false,
      location: map['location'],
      participants: List<String>.from(map['participants'] ?? []),
    );
  }

  // Copy with method
  TimeBlock copyWith({
    String? title,
    String? taskId,
    DateTime? startTime,
    DateTime? endTime,
    Color? color,
    String? description,
    bool? isCompleted,
    bool? isFlexible,
    String? categoryId,
    List<String>? notifications,
    String? recurrenceRule,
    bool? isRecurring,
    String? location,
    List<String>? participants,
  }) {
    return TimeBlock(
      id: id,
      title: title ?? this.title,
      taskId: taskId ?? this.taskId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isFlexible: isFlexible ?? this.isFlexible,
      categoryId: categoryId ?? this.categoryId,
      notifications: notifications ?? this.notifications,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      isRecurring: isRecurring ?? this.isRecurring,
      location: location ?? this.location,
      participants: participants ?? this.participants,
    );
  }

  // Check if this time block overlaps with another
  bool overlapsWith(TimeBlock other) {
    return startTime.isBefore(other.endTime) && endTime.isAfter(other.startTime);
  }

  // Check if a datetime falls within this time block
  bool containsTime(DateTime time) {
    return time.isAfter(startTime) && time.isBefore(endTime);
  }
}
