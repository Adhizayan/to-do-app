import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/task_provider.dart';
import '../utils/theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<Map<String, dynamic>>(
            future: provider.getStatistics(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final stats = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildOverviewCard(context, stats),
                  const SizedBox(height: 16),
                  _buildProgressCard(context, stats),
                  const SizedBox(height: 16),
                  _buildPriorityDistribution(context, provider),
                  const SizedBox(height: 16),
                  _buildCategoryStats(context, provider),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Total Tasks',
                  stats['totalTasks'].toString(),
                  Icons.task,
                  Colors.blue,
                ),
                _buildStatItem(
                  context,
                  'Completed',
                  stats['completedTasks'].toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  context,
                  'Overdue',
                  stats['overdueTasks'].toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, Map<String, dynamic> stats) {
    final completionRate = (stats['completionRate'] as double) / 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completion Rate',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Center(
              child: CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 12.0,
                percent: completionRate,
                center: Text(
                  '${(completionRate * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: AppTheme.primaryColor,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProgressStat(
                  context,
                  'Pending',
                  stats['pendingTasks'].toString(),
                  Colors.orange,
                ),
                _buildProgressStat(
                  context,
                  'In Progress',
                  stats['inProgressTasks'].toString(),
                  Colors.blue,
                ),
                _buildProgressStat(
                  context,
                  'Completed',
                  stats['completedTasks'].toString(),
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPriorityDistribution(BuildContext context, TaskProvider provider) {
    final tasks = provider.tasks;
    final priorityCounts = <String, int>{
      'Low': tasks.where((t) => t.priority.index == 0).length,
      'Medium': tasks.where((t) => t.priority.index == 1).length,
      'High': tasks.where((t) => t.priority.index == 2).length,
      'Urgent': tasks.where((t) => t.priority.index == 3).length,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Priority Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...priorityCounts.entries.map((entry) {
              final percentage = tasks.isEmpty
                  ? 0.0
                  : entry.value / tasks.length;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(entry.key),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearPercentIndicator(
                        percent: percentage,
                        lineHeight: 20,
                        progressColor: AppTheme.getPriorityColor(
                          priorityCounts.keys.toList().indexOf(entry.key),
                        ),
                        backgroundColor: Colors.grey.shade300,
                        center: Text(
                          entry.value.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryStats(BuildContext context, TaskProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...provider.categories.map((category) {
              final categoryTasks = provider.tasks
                  .where((t) => t.categoryId == category.id)
                  .length;
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 20,
                  ),
                ),
                title: Text(category.name),
                trailing: Text(
                  categoryTasks.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
