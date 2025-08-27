import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../models/time_block.dart';
import '../models/category.dart';
import '../services/database_service.dart';

class TaskProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;
  
  List<Task> _tasks = [];
  List<TimeBlock> _timeBlocks = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  TaskStatus? _filterStatus;
  TaskPriority? _filterPriority;

  // Getters
  List<Task> get tasks => _tasks;
  List<TimeBlock> get timeBlocks => _timeBlocks;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get selectedCategoryId => _selectedCategoryId;
  DateTime get selectedDate => _selectedDate;
  TaskStatus? get filterStatus => _filterStatus;
  TaskPriority? get filterPriority => _filterPriority;

  // Filtered tasks
  List<Task> get filteredTasks {
    List<Task> filtered = _tasks;

    // Filter by category
    if (_selectedCategoryId != null) {
      filtered = filtered.where((task) => task.categoryId == _selectedCategoryId).toList();
    }

    // Filter by status
    if (_filterStatus != null) {
      filtered = filtered.where((task) => task.status == _filterStatus).toList();
    }

    // Filter by priority
    if (_filterPriority != null) {
      filtered = filtered.where((task) => task.priority == _filterPriority).toList();
    }

    // Filter out archived tasks by default
    filtered = filtered.where((task) => !task.isArchived).toList();

    return filtered;
  }

  List<Task> get todayTasks {
    return _tasks.where((task) => task.isToday && !task.isArchived).toList();
  }

  List<Task> get overdueTasks {
    return _tasks.where((task) => task.isOverdue && !task.isArchived).toList();
  }

  List<Task> get upcomingTasks {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final nextWeek = DateTime.now().add(const Duration(days: 7));
    return _tasks.where((task) {
      if (task.dueDate == null || task.isArchived) return false;
      return task.dueDate!.isAfter(tomorrow.subtract(const Duration(seconds: 1))) &&
          task.dueDate!.isBefore(nextWeek) &&
          task.status != TaskStatus.completed;
    }).toList();
  }

  List<Task> get completedTasks {
    return _tasks.where((task) => task.status == TaskStatus.completed && !task.isArchived).toList();
  }

  List<TimeBlock> get todayTimeBlocks {
    return _timeBlocks.where((block) => block.isToday).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<TimeBlock> get selectedDateTimeBlocks {
    return _timeBlocks.where((block) {
      return block.startTime.year == _selectedDate.year &&
          block.startTime.month == _selectedDate.month &&
          block.startTime.day == _selectedDate.day;
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  // Initialize provider
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.initialize();
      await loadAllData();
    } catch (e) {
      debugPrint('Error initializing TaskProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load all data from database
  Future<void> loadAllData() async {
    await Future.wait([
      loadTasks(),
      loadTimeBlocks(),
      loadCategories(),
    ]);
  }

  // Task Operations
  Future<void> loadTasks() async {
    try {
      _tasks = await _dbService.getAllTasks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _dbService.saveTask(task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _dbService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _dbService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      // Also remove associated time blocks
      final blocksToRemove = _timeBlocks.where((block) => block.taskId == taskId).toList();
      for (var block in blocksToRemove) {
        await deleteTimeBlock(block.id);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final newStatus = task.status == TaskStatus.completed 
        ? TaskStatus.pending 
        : TaskStatus.completed;
    
    final updatedTask = task.copyWith(status: newStatus);
    await updateTask(updatedTask);
  }

  Future<void> archiveTask(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updatedTask = task.copyWith(isArchived: true);
    await updateTask(updatedTask);
  }

  // TimeBlock Operations
  Future<void> loadTimeBlocks() async {
    try {
      _timeBlocks = await _dbService.getAllTimeBlocks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading time blocks: $e');
    }
  }

  Future<void> addTimeBlock(TimeBlock timeBlock) async {
    try {
      // Check for overlaps
      final overlaps = _timeBlocks.any((block) => 
        block.id != timeBlock.id && block.overlapsWith(timeBlock));
      
      if (overlaps && !timeBlock.isFlexible) {
        throw Exception('Time block overlaps with existing block');
      }

      await _dbService.saveTimeBlock(timeBlock);
      _timeBlocks.add(timeBlock);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding time block: $e');
      rethrow;
    }
  }

  Future<void> updateTimeBlock(TimeBlock timeBlock) async {
    try {
      await _dbService.updateTimeBlock(timeBlock);
      final index = _timeBlocks.indexWhere((b) => b.id == timeBlock.id);
      if (index != -1) {
        _timeBlocks[index] = timeBlock;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating time block: $e');
    }
  }

  Future<void> deleteTimeBlock(String blockId) async {
    try {
      await _dbService.deleteTimeBlock(blockId);
      _timeBlocks.removeWhere((block) => block.id == blockId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting time block: $e');
    }
  }

  Future<void> toggleTimeBlockCompletion(String blockId) async {
    final block = _timeBlocks.firstWhere((b) => b.id == blockId);
    final updatedBlock = block.copyWith(isCompleted: !block.isCompleted);
    await updateTimeBlock(updatedBlock);

    // If the time block is linked to a task, update task progress
    if (block.taskId != null) {
      final task = _tasks.firstWhere((t) => t.id == block.taskId);
      if (updatedBlock.isCompleted) {
        final updatedTask = task.copyWith(
          actualDuration: task.actualDuration + block.duration.inMinutes,
        );
        await updateTask(updatedTask);
      }
    }
  }

  // Category Operations
  Future<void> loadCategories() async {
    try {
      _categories = await _dbService.getAllCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await _dbService.saveCategory(category);
      _categories.add(category);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding category: $e');
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _dbService.updateCategory(category);
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _dbService.deleteCategory(categoryId);
      _categories.removeWhere((category) => category.id == categoryId);
      
      // Update tasks with this category
      for (var task in _tasks.where((t) => t.categoryId == categoryId)) {
        final updatedTask = task.copyWith(categoryId: null);
        await updateTask(updatedTask);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting category: $e');
    }
  }

  // Filter Operations
  void setSelectedCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setFilterStatus(TaskStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setFilterPriority(TaskPriority? priority) {
    _filterPriority = priority;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategoryId = null;
    _filterStatus = null;
    _filterPriority = null;
    notifyListeners();
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    return await _dbService.getStatistics();
  }

  // Search
  List<Task> searchTasks(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _tasks.where((task) {
      return task.title.toLowerCase().contains(lowercaseQuery) ||
          task.description.toLowerCase().contains(lowercaseQuery) ||
          task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Batch Operations
  Future<void> markMultipleTasksComplete(List<String> taskIds) async {
    for (var taskId in taskIds) {
      final task = _tasks.firstWhere((t) => t.id == taskId);
      final updatedTask = task.copyWith(status: TaskStatus.completed);
      await updateTask(updatedTask);
    }
  }

  Future<void> deleteMultipleTasks(List<String> taskIds) async {
    for (var taskId in taskIds) {
      await deleteTask(taskId);
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _dbService.clearAllData();
    await loadAllData();
  }
}
