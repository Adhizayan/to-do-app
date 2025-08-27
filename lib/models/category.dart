import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Category {
  final String id;
  String name;
  String? description;
  IconData icon;
  Color color;
  int taskCount;
  DateTime createdAt;
  DateTime updatedAt;
  bool isDefault;
  int order;

  Category({
    String? id,
    required this.name,
    this.description,
    IconData? icon,
    Color? color,
    this.taskCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isDefault = false,
    this.order = 0,
  })  : id = id ?? const Uuid().v4(),
        icon = icon ?? Icons.folder,
        color = color ?? Colors.blue,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon.codePoint,
      'color': color.value,
      'taskCount': taskCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDefault': isDefault,
      'order': order,
    };
  }

  // Create from Map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: IconData(map['icon'] ?? Icons.folder.codePoint, fontFamily: 'MaterialIcons'),
      color: Color(map['color'] ?? Colors.blue.value),
      taskCount: map['taskCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isDefault: map['isDefault'] ?? false,
      order: map['order'] ?? 0,
    );
  }

  // Copy with method
  Category copyWith({
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    int? taskCount,
    bool? isDefault,
    int? order,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      taskCount: taskCount ?? this.taskCount,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isDefault: isDefault ?? this.isDefault,
      order: order ?? this.order,
    );
  }

  // Default categories
  static List<Category> getDefaultCategories() {
    return [
      Category(
        name: 'Personal',
        description: 'Personal tasks and reminders',
        icon: Icons.person,
        color: Colors.purple,
        isDefault: true,
        order: 0,
      ),
      Category(
        name: 'Work',
        description: 'Work-related tasks and projects',
        icon: Icons.work,
        color: Colors.blue,
        isDefault: true,
        order: 1,
      ),
      Category(
        name: 'Shopping',
        description: 'Shopping lists and errands',
        icon: Icons.shopping_cart,
        color: Colors.green,
        isDefault: true,
        order: 2,
      ),
      Category(
        name: 'Health',
        description: 'Health and fitness goals',
        icon: Icons.favorite,
        color: Colors.red,
        isDefault: true,
        order: 3,
      ),
      Category(
        name: 'Learning',
        description: 'Educational goals and courses',
        icon: Icons.school,
        color: Colors.orange,
        isDefault: true,
        order: 4,
      ),
    ];
  }
}
