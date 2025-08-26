import React, { useMemo } from 'react';
import { useTodo } from '../context/TodoContext';
import { 
  TrendingUp, 
  Clock, 
  Target, 
  Award, 
  Calendar,
  CheckCircle,
  AlertCircle,
  BarChart3
} from 'lucide-react';
import { format, startOfWeek, endOfWeek, isWithinInterval, subDays } from 'date-fns';

const StatsPanel: React.FC = () => {
  const { state } = useTodo();

  // Calculate statistics
  const stats = useMemo(() => {
    const totalTodos = state.todos.length;
    const completedTodos = state.todos.filter(t => t.completed).length;
    const pendingTodos = totalTodos - completedTodos;
    const completionRate = totalTodos > 0 ? (completedTodos / totalTodos) * 100 : 0;

    // Priority breakdown
    const priorityBreakdown = {
      urgent: state.todos.filter(t => t.priority === 'urgent' && !t.completed).length,
      high: state.todos.filter(t => t.priority === 'high' && !t.completed).length,
      medium: state.todos.filter(t => t.priority === 'medium' && !t.completed).length,
      low: state.todos.filter(t => t.priority === 'low' && !t.completed).length,
    };

    // Category breakdown
    const categoryStats = state.categories.map(category => {
      const categoryTodos = state.todos.filter(t => t.category.id === category.id);
      const completedInCategory = categoryTodos.filter(t => t.completed).length;
      return {
        ...category,
        total: categoryTodos.length,
        completed: completedInCategory,
        pending: categoryTodos.length - completedInCategory,
        completionRate: categoryTodos.length > 0 ? (completedInCategory / categoryTodos.length) * 100 : 0,
      };
    });

    // Time blocks stats
    const totalTimeBlocks = state.timeBlocks.length;
    const completedTimeBlocks = state.timeBlocks.filter(b => b.completed).length;
    const totalTimeSpent = state.timeBlocks
      .filter(b => b.completed)
      .reduce((sum, block) => sum + block.duration, 0);

    // This week's progress
    const now = new Date();
    const weekStart = startOfWeek(now);
    const weekEnd = endOfWeek(now);
    
    const thisWeekTodos = state.todos.filter(todo =>
      isWithinInterval(todo.createdAt, { start: weekStart, end: weekEnd })
    );
    const thisWeekCompleted = thisWeekTodos.filter(t => t.completed).length;

    // Productivity score (simple calculation)
    const productivityScore = Math.min(100, Math.round(
      (completionRate * 0.4) + 
      (totalTimeBlocks > 0 ? (completedTimeBlocks / totalTimeBlocks) * 100 * 0.3 : 0) +
      (priorityBreakdown.urgent === 0 ? 30 : Math.max(0, 30 - priorityBreakdown.urgent * 5))
    ));

    return {
      totalTodos,
      completedTodos,
      pendingTodos,
      completionRate,
      priorityBreakdown,
      categoryStats,
      totalTimeBlocks,
      completedTimeBlocks,
      totalTimeSpent,
      thisWeekTodos: thisWeekTodos.length,
      thisWeekCompleted,
      productivityScore,
    };
  }, [state.todos, state.categories, state.timeBlocks]);

  const formatTime = (minutes: number) => {
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    if (hours > 0) {
      return `${hours}h ${mins}m`;
    }
    return `${mins}m`;
  };

  const getScoreColor = (score: number) => {
    if (score >= 80) return 'text-green-600';
    if (score >= 60) return 'text-yellow-600';
    return 'text-red-600';
  };

  const getScoreBackground = (score: number) => {
    if (score >= 80) return 'bg-green-100';
    if (score >= 60) return 'bg-yellow-100';
    return 'bg-red-100';
  };

  return (
    <div className="h-full overflow-y-auto bg-gray-50">
      <div className="p-6 max-w-6xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Analytics & Insights</h2>
          <p className="text-gray-600">Track your productivity and progress over time</p>
        </div>

        {/* Key Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="card p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Total Tasks</p>
                <p className="text-2xl font-bold text-gray-900">{stats.totalTodos}</p>
              </div>
              <div className="p-3 bg-blue-100 rounded-lg">
                <CheckCircle className="h-6 w-6 text-blue-600" />
              </div>
            </div>
          </div>

          <div className="card p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Completed</p>
                <p className="text-2xl font-bold text-green-600">{stats.completedTodos}</p>
              </div>
              <div className="p-3 bg-green-100 rounded-lg">
                <Target className="h-6 w-6 text-green-600" />
              </div>
            </div>
          </div>

          <div className="card p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Time Spent</p>
                <p className="text-2xl font-bold text-purple-600">{formatTime(stats.totalTimeSpent)}</p>
              </div>
              <div className="p-3 bg-purple-100 rounded-lg">
                <Clock className="h-6 w-6 text-purple-600" />
              </div>
            </div>
          </div>

          <div className="card p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Productivity Score</p>
                <p className={`text-2xl font-bold ${getScoreColor(stats.productivityScore)}`}>
                  {stats.productivityScore}%
                </p>
              </div>
              <div className={`p-3 rounded-lg ${getScoreBackground(stats.productivityScore)}`}>
                <TrendingUp className={`h-6 w-6 ${getScoreColor(stats.productivityScore)}`} />
              </div>
            </div>
          </div>
        </div>

        {/* Completion Rate */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <div className="card p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Overall Progress</h3>
            <div className="space-y-4">
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-sm font-medium text-gray-600">Completion Rate</span>
                  <span className="text-sm font-bold text-gray-900">{stats.completionRate.toFixed(1)}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className="bg-green-600 h-2 rounded-full transition-all duration-300"
                    style={{ width: `${stats.completionRate}%` }}
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4 text-center">
                <div>
                  <div className="text-lg font-bold text-green-600">{stats.completedTodos}</div>
                  <div className="text-sm text-gray-500">Completed</div>
                </div>
                <div>
                  <div className="text-lg font-bold text-gray-600">{stats.pendingTodos}</div>
                  <div className="text-sm text-gray-500">Pending</div>
                </div>
              </div>
            </div>
          </div>

          <div className="card p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">This Week</h3>
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Tasks Created</span>
                <span className="font-semibold">{stats.thisWeekTodos}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Tasks Completed</span>
                <span className="font-semibold text-green-600">{stats.thisWeekCompleted}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Time Blocks</span>
                <span className="font-semibold">{stats.completedTimeBlocks}/{stats.totalTimeBlocks}</span>
              </div>
            </div>
          </div>
        </div>

        {/* Priority Breakdown */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <div className="card p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Priority Breakdown</h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                  <span className="text-sm font-medium">Urgent</span>
                </div>
                <span className="text-sm font-bold text-red-600">{stats.priorityBreakdown.urgent}</span>
              </div>
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-orange-500 rounded-full"></div>
                  <span className="text-sm font-medium">High</span>
                </div>
                <span className="text-sm font-bold text-orange-600">{stats.priorityBreakdown.high}</span>
              </div>
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
                  <span className="text-sm font-medium">Medium</span>
                </div>
                <span className="text-sm font-bold text-yellow-600">{stats.priorityBreakdown.medium}</span>
              </div>
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                  <span className="text-sm font-medium">Low</span>
                </div>
                <span className="text-sm font-bold text-green-600">{stats.priorityBreakdown.low}</span>
              </div>
            </div>
          </div>

          <div className="card p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Category Performance</h3>
            <div className="space-y-3">
              {stats.categoryStats.map(category => (
                <div key={category.id}>
                  <div className="flex items-center justify-between mb-1">
                    <div className="flex items-center space-x-2">
                      <span className="text-sm">{category.icon}</span>
                      <span className="text-sm font-medium">{category.name}</span>
                    </div>
                    <span className="text-sm text-gray-500">
                      {category.completed}/{category.total}
                    </span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-1.5">
                    <div 
                      className="h-1.5 rounded-full transition-all duration-300"
                      style={{ 
                        width: `${category.completionRate}%`,
                        backgroundColor: category.color 
                      }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Insights */}
        <div className="card p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Insights & Recommendations</h3>
          <div className="space-y-3">
            {stats.priorityBreakdown.urgent > 0 && (
              <div className="flex items-start space-x-3 p-3 bg-red-50 rounded-lg">
                <AlertCircle className="h-5 w-5 text-red-600 mt-0.5" />
                <div>
                  <p className="text-sm font-medium text-red-800">
                    You have {stats.priorityBreakdown.urgent} urgent task{stats.priorityBreakdown.urgent > 1 ? 's' : ''} pending
                  </p>
                  <p className="text-xs text-red-600">Consider tackling these first to improve your productivity score</p>
                </div>
              </div>
            )}
            
            {stats.completionRate > 80 && (
              <div className="flex items-start space-x-3 p-3 bg-green-50 rounded-lg">
                <Award className="h-5 w-5 text-green-600 mt-0.5" />
                <div>
                  <p className="text-sm font-medium text-green-800">Great job! You're maintaining a high completion rate</p>
                  <p className="text-xs text-green-600">Keep up the excellent work</p>
                </div>
              </div>
            )}

            {stats.totalTimeSpent > 0 && (
              <div className="flex items-start space-x-3 p-3 bg-blue-50 rounded-lg">
                <Clock className="h-5 w-5 text-blue-600 mt-0.5" />
                <div>
                  <p className="text-sm font-medium text-blue-800">
                    You've spent {formatTime(stats.totalTimeSpent)} on focused work
                  </p>
                  <p className="text-xs text-blue-600">Time blocking is helping you stay productive</p>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default StatsPanel;