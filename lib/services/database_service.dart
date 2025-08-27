import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/time_block.dart';
import '../models/category.dart';

class DatabaseService {
  static const String taskBoxName = 'tasks';
  static const String timeBlockBoxName = 'timeBlocks';
  static const String categoryBoxName = 'categories';
  static const String settingsBoxName = 'settings';

  static DatabaseService? _instance;
  late Box<Map> _taskBox;
  late Box<Map> _timeBlockBox;
  late Box<Map> _categoryBox;
  late Box _settingsBox;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Future<void> initialize() async {
    await Hive.initFlutter();
    _taskBox = await Hive.openBox<Map>(taskBoxName);
    _timeBlockBox = await Hive.openBox<Map>(timeBlockBoxName);
    _categoryBox = await Hive.openBox<Map>(categoryBoxName);
    _settingsBox = await Hive.openBox(settingsBoxName);

    // Initialize default categories if empty
    if (_categoryBox.isEmpty) {
      await _initializeDefaultCategories();
    }
  }

  Future<void> _initializeDefaultCategories() async {
    final defaultCategories = Category.getDefaultCategories();
    for (var category in defaultCategories) {
      await saveCategory(category);
    }
  }

  // Task Operations
  Future<void> saveTask(Task task) async {
    await _taskBox.put(task.id, task.toMap());
  }

  Future<Task?> getTask(String id) async {
    final taskMap = _taskBox.get(id);
    if (taskMap != null) {
      return Task.fromMap(Map<String, dynamic>.from(taskMap));
    }
    return null;
  }

  Future<List<Task>> getAllTasks() async {
    return _taskBox.values
        .map((taskMap) => Task.fromMap(Map<String, dynamic>.from(taskMap)))
        .toList();
  }

  Future<List<Task>> getTasksByCategory(String categoryId) async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.categoryId == categoryId).toList();
  }

  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.status == status).toList();
  }

  Future<List<Task>> getTodayTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.isToday).toList();
  }

  Future<List<Task>> getOverdueTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.isOverdue).toList();
  }

  Future<List<Task>> getUpcomingTasks(int days) async {
    final tasks = await getAllTasks();
    final endDate = DateTime.now().add(Duration(days: days));
    return tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isAfter(DateTime.now()) &&
          task.dueDate!.isBefore(endDate) &&
          task.status != TaskStatus.completed;
    }).toList();
  }

  Future<void> updateTask(Task task) async {
    task.updatedAt = DateTime.now();
    await _taskBox.put(task.id, task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  Future<void> deleteAllTasks() async {
    await _taskBox.clear();
  }

  // TimeBlock Operations
  Future<void> saveTimeBlock(TimeBlock timeBlock) async {
    await _timeBlockBox.put(timeBlock.id, timeBlock.toMap());
  }

  Future<TimeBlock?> getTimeBlock(String id) async {
    final blockMap = _timeBlockBox.get(id);
    if (blockMap != null) {
      return TimeBlock.fromMap(Map<String, dynamic>.from(blockMap));
    }
    return null;
  }

  Future<List<TimeBlock>> getAllTimeBlocks() async {
    return _timeBlockBox.values
        .map((blockMap) => TimeBlock.fromMap(Map<String, dynamic>.from(blockMap)))
        .toList();
  }

  Future<List<TimeBlock>> getTimeBlocksForDate(DateTime date) async {
    final blocks = await getAllTimeBlocks();
    return blocks.where((block) {
      return block.startTime.year == date.year &&
          block.startTime.month == date.month &&
          block.startTime.day == date.day;
    }).toList();
  }

  Future<List<TimeBlock>> getTimeBlocksForRange(DateTime start, DateTime end) async {
    final blocks = await getAllTimeBlocks();
    return blocks.where((block) {
      return block.startTime.isAfter(start.subtract(const Duration(seconds: 1))) &&
          block.startTime.isBefore(end.add(const Duration(seconds: 1)));
    }).toList();
  }

  Future<List<TimeBlock>> getTodayTimeBlocks() async {
    return getTimeBlocksForDate(DateTime.now());
  }

  Future<void> updateTimeBlock(TimeBlock timeBlock) async {
    timeBlock.updatedAt = DateTime.now();
    await _timeBlockBox.put(timeBlock.id, timeBlock.toMap());
  }

  Future<void> deleteTimeBlock(String id) async {
    await _timeBlockBox.delete(id);
  }

  Future<void> deleteAllTimeBlocks() async {
    await _timeBlockBox.clear();
  }

  // Category Operations
  Future<void> saveCategory(Category category) async {
    await _categoryBox.put(category.id, category.toMap());
  }

  Future<Category?> getCategory(String id) async {
    final categoryMap = _categoryBox.get(id);
    if (categoryMap != null) {
      return Category.fromMap(Map<String, dynamic>.from(categoryMap));
    }
    return null;
  }

  Future<List<Category>> getAllCategories() async {
    final categories = _categoryBox.values
        .map((categoryMap) => Category.fromMap(Map<String, dynamic>.from(categoryMap)))
        .toList();
    categories.sort((a, b) => a.order.compareTo(b.order));
    return categories;
  }

  Future<void> updateCategory(Category category) async {
    category.updatedAt = DateTime.now();
    await _categoryBox.put(category.id, category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    // Don't delete default categories
    final category = await getCategory(id);
    if (category != null && !category.isDefault) {
      await _categoryBox.delete(id);
    }
  }

  // Settings Operations
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  Future<T?> getSetting<T>(String key, {T? defaultValue}) async {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final tasks = await getAllTasks();
    final timeBlocks = await getAllTimeBlocks();
    
    final completedTasks = tasks.where((task) => task.status == TaskStatus.completed).length;
    final pendingTasks = tasks.where((task) => task.status == TaskStatus.pending).length;
    final inProgressTasks = tasks.where((task) => task.status == TaskStatus.inProgress).length;
    final overdueTasks = tasks.where((task) => task.isOverdue).length;
    
    final todayBlocks = await getTodayTimeBlocks();
    final todayCompletedBlocks = todayBlocks.where((block) => block.isCompleted).length;
    
    return {
      'totalTasks': tasks.length,
      'completedTasks': completedTasks,
      'pendingTasks': pendingTasks,
      'inProgressTasks': inProgressTasks,
      'overdueTasks': overdueTasks,
      'totalTimeBlocks': timeBlocks.length,
      'todayTimeBlocks': todayBlocks.length,
      'todayCompletedBlocks': todayCompletedBlocks,
      'completionRate': tasks.isEmpty ? 0.0 : (completedTasks / tasks.length) * 100,
    };
  }

  // Cleanup
  Future<void> clearAllData() async {
    await _taskBox.clear();
    await _timeBlockBox.clear();
    await _categoryBox.clear();
    await _settingsBox.clear();
    await _initializeDefaultCategories();
  }

  Future<void> close() async {
    await _taskBox.close();
    await _timeBlockBox.close();
    await _categoryBox.close();
    await _settingsBox.close();
  }
}
