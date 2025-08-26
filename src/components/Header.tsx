import React, { useState } from 'react';
import { Menu, Calendar, Plus } from 'lucide-react';
import { useTodo } from '../context/TodoContext';
import { format } from 'date-fns';
import AddTodoModal from './AddTodoModal';

interface HeaderProps {
  onToggleSidebar: () => void;
  sidebarOpen: boolean;
}

const Header: React.FC<HeaderProps> = ({ onToggleSidebar, sidebarOpen }) => {
  const { state } = useTodo();
  const [showAddModal, setShowAddModal] = useState(false);

  return (
    <>
      <header className="bg-white border-b border-gray-200 px-6 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <button
              onClick={onToggleSidebar}
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
              aria-label="Toggle sidebar"
            >
              <Menu size={20} className="text-gray-600" />
            </button>
            
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center">
                <Calendar size={18} className="text-white" />
              </div>
              <div>
                <h1 className="text-xl font-semibold text-gray-900">TaskFlow</h1>
                <p className="text-sm text-gray-500">
                  {format(state.selectedDate, 'EEEE, MMMM d, yyyy')}
                </p>
              </div>
            </div>
          </div>

          <div className="flex items-center space-x-3">
            <div className="hidden sm:flex items-center space-x-4 text-sm text-gray-600">
              <span>{state.todos.filter(t => !t.completed).length} tasks pending</span>
              <span>{state.todos.filter(t => t.completed).length} completed</span>
            </div>
            
            <button 
              onClick={() => setShowAddModal(true)}
              className="btn-primary flex items-center space-x-2"
            >
              <Plus size={16} />
              <span className="hidden sm:inline">Add Task</span>
            </button>
          </div>
        </div>
      </header>

      {showAddModal && (
        <AddTodoModal onClose={() => setShowAddModal(false)} />
      )}
    </>
  );
};

export default Header;