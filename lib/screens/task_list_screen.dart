import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../utils/theme.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              _buildSearchBar(),
              TabBar(
                controller: _tabController,
                isScrollable: false,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Today'),
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Completed'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildTaskList(provider.filteredTasks, provider),
              _buildTaskList(provider.todayTasks, provider),
              _buildTaskList(provider.upcomingTasks, provider),
              _buildTaskList(provider.completedTasks, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, TaskProvider provider) {
    // Filter tasks based on search query
    if (_searchQuery.isNotEmpty) {
      tasks = provider.searchTasks(_searchQuery);
    }

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TaskCard(
            task: task,
            onStatusToggle: () => provider.toggleTaskStatus(task.id),
            onDelete: () => _showDeleteDialog(context, provider, task),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, TaskProvider provider, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTask(task.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
