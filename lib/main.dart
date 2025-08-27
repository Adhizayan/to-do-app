import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/time_block_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/add_time_block_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const TodoTimeBlockApp());
}

class TodoTimeBlockApp extends StatelessWidget {
  const TodoTimeBlockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider()..initialize(),
      child: MaterialApp(
        title: 'Todo TimeBlock',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainNavigationScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/tasks': (context) => const TaskListScreen(),
          '/timeblock': (context) => const TimeBlockScreen(),
'add-task': (context) => const AddTaskScreen(),
          '/statistics': (context) => const StatisticsScreen(),
          '/add-timeblock': (context) => const AddTimeBlockScreen(),
        },
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const TaskListScreen(),
    const TimeBlockScreen(),
    const StatisticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: _selectedIndex < 3
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-task');
              },
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 6,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_rounded, 'Home', 0),
            _buildNavItem(Icons.list_alt_rounded, 'Tasks', 1),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(Icons.calendar_today_rounded, 'TimeBlock', 2),
            _buildNavItem(Icons.bar_chart_rounded, 'Stats', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.primaryColor
                    : theme.unselectedWidgetColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? theme.primaryColor
                      : theme.unselectedWidgetColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
