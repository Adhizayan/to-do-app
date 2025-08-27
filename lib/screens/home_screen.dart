import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/time_block.dart';
import '../widgets/task_card.dart';
import '../widgets/time_block_card.dart';
import '../utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                _buildHeader(context, provider),
                _buildDailyProgress(context, provider),
                _buildTodayTimeBlocks(context, provider),
                _buildTodayTasks(context, provider),
                _buildUpcomingTasks(context, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TaskProvider provider) {
    final now = DateTime.now();
    final greeting = _getGreeting();

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMMM d').format(now),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyProgress(BuildContext context, TaskProvider provider) {
    final todayTasks = provider.todayTasks;
    final completedTasks = todayTasks.where((t) => t.status == TaskStatus.completed).length;
    final totalTasks = todayTasks.length;
    final percentage = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    final todayBlocks = provider.todayTimeBlocks;
    final completedBlocks = todayBlocks.where((b) => b.isCompleted).length;
    final totalBlocks = todayBlocks.length;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressIndicator(
                  context,
                  'Tasks',
                  completedTasks,
                  totalTasks,
                  percentage,
                  AppTheme.primaryColor,
                ),
                _buildProgressIndicator(
                  context,
                  'Time Blocks',
                  completedBlocks,
                  totalBlocks,
                  totalBlocks > 0 ? completedBlocks / totalBlocks : 0.0,
                  AppTheme.secondaryColor,
                ),
                _buildStatItem(
                  context,
                  'Overdue',
                  provider.overdueTasks.length.toString(),
                  AppTheme.errorColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    String label,
    int completed,
    int total,
    double percentage,
    Color color,
  ) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 35.0,
          lineWidth: 6.0,
          percent: percentage,
          center: Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          '$completed/$total',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTodayTimeBlocks(BuildContext context, TaskProvider provider) {
    final blocks = provider.todayTimeBlocks;

    if (blocks.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Schedule",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to time block screen
                  },
                  child: const Text('See all'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: TimeBlockCard(timeBlock: blocks[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTasks(BuildContext context, TaskProvider provider) {
    final tasks = provider.todayTasks
        .where((t) => t.status != TaskStatus.completed)
        .take(5)
        .toList();

    if (tasks.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              "Today's Tasks",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...tasks.map((task) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TaskCard(task: task),
              )),
        ],
      ),
    );
  }

  Widget _buildUpcomingTasks(BuildContext context, TaskProvider provider) {
    final tasks = provider.upcomingTasks.take(5).toList();

    if (tasks.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox(height: 80));
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              'Upcoming Tasks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...tasks.map((task) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TaskCard(task: task),
              )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning! ☀️';
    } else if (hour < 17) {
      return 'Good Afternoon! 🌤️';
    } else {
      return 'Good Evening! 🌙';
    }
  }
}
