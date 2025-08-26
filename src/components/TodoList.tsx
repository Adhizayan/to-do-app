import React, { useState, useMemo } from 'react';
import { useTodo } from '../context/TodoContext';
import TodoItem from './TodoItem';
import { Todo, Priority } from '../types';
import { SortAsc, Filter, CheckSquare } from 'lucide-react';

type SortBy = 'dueDate' | 'priority' | 'created' | 'alphabetical';
type FilterBy = 'all' | 'pending' | 'completed' | Priority;

const TodoList: React.FC = () => {
  const { state } = useTodo();
  const [sortBy, setSortBy] = useState<SortBy>('priority');
  const [filterBy, setFilterBy] = useState<FilterBy>('all');

  const filteredAndSortedTodos = useMemo(() => {
    let filtered = [...state.todos];

    // Apply filters
    switch (filterBy) {
      case 'pending':
        filtered = filtered.filter(todo => !todo.completed);
        break;
      case 'completed':
        filtered = filtered.filter(todo => todo.completed);
        break;
      case 'urgent':
      case 'high':
      case 'medium':
      case 'low':
        filtered = filtered.filter(todo => todo.priority === filterBy);
        break;
      default:
        break;
    }

    // Apply sorting
    filtered.sort((a, b) => {
      switch (sortBy) {
        case 'dueDate':
          if (!a.dueDate && !b.dueDate) return 0;
          if (!a.dueDate) return 1;
          if (!b.dueDate) return -1;
          return a.dueDate.getTime() - b.dueDate.getTime();
        
        case 'priority':
          const priorityOrder = { urgent: 0, high: 1, medium: 2, low: 3 };
          return priorityOrder[a.priority] - priorityOrder[b.priority];
        
        case 'created':
          return b.createdAt.getTime() - a.createdAt.getTime();
        
        case 'alphabetical':
          return a.title.localeCompare(b.title);
        
        default:
          return 0;
      }
    });

    return filtered;
  }, [state.todos, sortBy, filterBy]);

  const pendingTodos = filteredAndSortedTodos.filter(todo => !todo.completed);
  const completedTodos = filteredAndSortedTodos.filter(todo => todo.completed);

  return (
    <div className="h-full flex flex-col bg-gray-50">
      {/* Controls */}
      <div className="bg-white border-b border-gray-200 p-4">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-gray-900">
            Tasks ({pendingTodos.length} pending)
          </h2>
          
          <div className="flex items-center space-x-3">
            {/* Filter Dropdown */}
            <div className="relative">
              <select
                value={filterBy}
                onChange={(e) => setFilterBy(e.target.value as FilterBy)}
                className="appearance-none bg-white border border-gray-300 rounded-lg px-3 py-2 pr-8 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
              >
                <option value="all">All Tasks</option>
                <option value="pending">Pending</option>
                <option value="completed">Completed</option>
                <option value="urgent">Urgent</option>
                <option value="high">High Priority</option>
                <option value="medium">Medium Priority</option>
                <option value="low">Low Priority</option>
              </select>
              <Filter size={16} className="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none" />
            </div>

            {/* Sort Dropdown */}
            <div className="relative">
              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value as SortBy)}
                className="appearance-none bg-white border border-gray-300 rounded-lg px-3 py-2 pr-8 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
              >
                <option value="priority">Priority</option>
                <option value="dueDate">Due Date</option>
                <option value="created">Created</option>
                <option value="alphabetical">A-Z</option>
              </select>
              <SortAsc size={16} className="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none" />
            </div>
          </div>
        </div>

        {/* Quick Stats */}
        <div className="grid grid-cols-4 gap-4">
          <div className="bg-gray-50 rounded-lg p-3 text-center">
            <div className="text-lg font-semibold text-gray-900">{state.todos.length}</div>
            <div className="text-sm text-gray-500">Total</div>
          </div>
          <div className="bg-blue-50 rounded-lg p-3 text-center">
            <div className="text-lg font-semibold text-blue-600">{pendingTodos.length}</div>
            <div className="text-sm text-blue-500">Pending</div>
          </div>
          <div className="bg-green-50 rounded-lg p-3 text-center">
            <div className="text-lg font-semibold text-green-600">{completedTodos.length}</div>
            <div className="text-sm text-green-500">Completed</div>
          </div>
          <div className="bg-orange-50 rounded-lg p-3 text-center">
            <div className="text-lg font-semibold text-orange-600">
              {state.todos.filter(t => t.priority === 'urgent' && !t.completed).length}
            </div>
            <div className="text-sm text-orange-500">Urgent</div>
          </div>
        </div>
      </div>

      {/* Todo List */}
      <div className="flex-1 overflow-y-auto p-4">
        {filteredAndSortedTodos.length === 0 ? (
          <div className="text-center py-12">
            <div className="text-gray-400 mb-4">
              <CheckSquare size={48} className="mx-auto" />
            </div>
            <h3 className="text-lg font-medium text-gray-900 mb-2">No tasks found</h3>
            <p className="text-gray-500">
              {filterBy === 'all' 
                ? "Start by adding your first task!" 
                : `No tasks match the current filter: ${filterBy}`
              }
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {/* Pending Tasks */}
            {pendingTodos.length > 0 && (
              <div>
                <h3 className="text-sm font-medium text-gray-500 uppercase tracking-wide mb-3">
                  Pending ({pendingTodos.length})
                </h3>
                <div className="space-y-2">
                  {pendingTodos.map(todo => (
                    <TodoItem key={todo.id} todo={todo} />
                  ))}
                </div>
              </div>
            )}

            {/* Completed Tasks */}
            {completedTodos.length > 0 && (
              <div className="mt-8">
                <h3 className="text-sm font-medium text-gray-500 uppercase tracking-wide mb-3">
                  Completed ({completedTodos.length})
                </h3>
                <div className="space-y-2">
                  {completedTodos.map(todo => (
                    <TodoItem key={todo.id} todo={todo} />
                  ))}
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default TodoList;