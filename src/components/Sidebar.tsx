import React, { useState } from 'react';
import { 
  CheckSquare, 
  Calendar, 
  BarChart3, 
  Settings, 
  Plus,
  Filter,
  Search
} from 'lucide-react';
import { useTodo } from '../context/TodoContext';
import AddTodoModal from './AddTodoModal';

interface SidebarProps {
  onViewModeChange: (mode: 'todos' | 'calendar' | 'stats') => void;
  currentView: 'todos' | 'calendar' | 'stats';
}

const Sidebar: React.FC<SidebarProps> = ({ onViewModeChange, currentView }) => {
  const { state } = useTodo();
  const [showAddModal, setShowAddModal] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  const navItems = [
    { id: 'todos', label: 'Tasks', icon: CheckSquare, count: state.todos.filter(t => !t.completed).length },
    { id: 'calendar', label: 'Time Blocks', icon: Calendar, count: state.timeBlocks.length },
    { id: 'stats', label: 'Analytics', icon: BarChart3, count: null },
  ];

  const priorityFilters = [
    { label: 'Urgent', color: 'bg-red-500', count: state.todos.filter(t => t.priority === 'urgent' && !t.completed).length },
    { label: 'High', color: 'bg-orange-500', count: state.todos.filter(t => t.priority === 'high' && !t.completed).length },
    { label: 'Medium', color: 'bg-yellow-500', count: state.todos.filter(t => t.priority === 'medium' && !t.completed).length },
    { label: 'Low', color: 'bg-green-500', count: state.todos.filter(t => t.priority === 'low' && !t.completed).length },
  ];

  return (
    <>
      <div className="bg-white h-full border-r border-gray-200 flex flex-col">
        {/* Search */}
        <div className="p-4 border-b border-gray-200">
          <div className="relative">
            <Search size={18} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search tasks..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
          </div>
        </div>

        {/* Quick Add */}
        <div className="p-4 border-b border-gray-200">
          <button
            onClick={() => setShowAddModal(true)}
            className="w-full btn-primary flex items-center justify-center space-x-2"
          >
            <Plus size={18} />
            <span>Add New Task</span>
          </button>
        </div>

        {/* Navigation */}
        <div className="p-4">
          <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-3">
            Navigation
          </h3>
          <nav className="space-y-1">
            {navItems.map((item) => {
              const Icon = item.icon;
              return (
                <button
                  key={item.id}
                  onClick={() => onViewModeChange(item.id as any)}
                  className={`w-full flex items-center justify-between px-3 py-2 rounded-lg text-left transition-colors ${
                    currentView === item.id
                      ? 'bg-primary-50 text-primary-700 border border-primary-200'
                      : 'text-gray-700 hover:bg-gray-100'
                  }`}
                >
                  <div className="flex items-center space-x-3">
                    <Icon size={18} />
                    <span className="font-medium">{item.label}</span>
                  </div>
                  {item.count !== null && (
                    <span className={`px-2 py-0.5 text-xs rounded-full ${
                      currentView === item.id
                        ? 'bg-primary-100 text-primary-600'
                        : 'bg-gray-100 text-gray-600'
                    }`}>
                      {item.count}
                    </span>
                  )}
                </button>
              );
            })}
          </nav>
        </div>

        {/* Priority Filters */}
        <div className="p-4 border-t border-gray-200">
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wide">
              Priority
            </h3>
            <Filter size={14} className="text-gray-400" />
          </div>
          <div className="space-y-2">
            {priorityFilters.map((filter) => (
              <div key={filter.label} className="flex items-center justify-between py-1">
                <div className="flex items-center space-x-3">
                  <div className={`w-3 h-3 rounded-full ${filter.color}`} />
                  <span className="text-sm text-gray-700">{filter.label}</span>
                </div>
                <span className="text-xs text-gray-500">{filter.count}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Categories */}
        <div className="p-4 border-t border-gray-200 flex-1">
          <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-3">
            Categories
          </h3>
          <div className="space-y-2">
            {state.categories.map((category) => {
              const todoCount = state.todos.filter(t => t.category.id === category.id && !t.completed).length;
              return (
                <div key={category.id} className="flex items-center justify-between py-1">
                  <div className="flex items-center space-x-3">
                    <span className="text-sm">{category.icon}</span>
                    <span className="text-sm text-gray-700">{category.name}</span>
                  </div>
                  <span className="text-xs text-gray-500">{todoCount}</span>
                </div>
              );
            })}
          </div>
        </div>

        {/* Settings */}
        <div className="p-4 border-t border-gray-200">
          <button className="w-full flex items-center space-x-3 px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition-colors">
            <Settings size={18} />
            <span>Settings</span>
          </button>
        </div>
      </div>

      {showAddModal && (
        <AddTodoModal onClose={() => setShowAddModal(false)} />
      )}
    </>
  );
};

export default Sidebar;