import React, { useState } from 'react';
import { Todo } from '../types';
import { useTodo } from '../context/TodoContext';
import { 
  Check, 
  Clock, 
  Calendar, 
  MoreHorizontal, 
  Edit, 
  Trash2, 
  Play 
} from 'lucide-react';
import { format, isToday, isTomorrow, isPast } from 'date-fns';

interface TodoItemProps {
  todo: Todo;
}

const TodoItem: React.FC<TodoItemProps> = ({ todo }) => {
  const { toggleTodo, deleteTodo, addTimeBlock } = useTodo();
  const [showOptions, setShowOptions] = useState(false);

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'urgent': return 'border-red-500 bg-red-50';
      case 'high': return 'border-orange-500 bg-orange-50';
      case 'medium': return 'border-yellow-500 bg-yellow-50';
      case 'low': return 'border-green-500 bg-green-50';
      default: return 'border-gray-300 bg-white';
    }
  };

  const getPriorityTextColor = (priority: string) => {
    switch (priority) {
      case 'urgent': return 'text-red-700';
      case 'high': return 'text-orange-700';
      case 'medium': return 'text-yellow-700';
      case 'low': return 'text-green-700';
      default: return 'text-gray-700';
    }
  };

  const formatDueDate = (date: Date) => {
    if (isToday(date)) return 'Today';
    if (isTomorrow(date)) return 'Tomorrow';
    return format(date, 'MMM d');
  };

  const getDueDateColor = (date: Date) => {
    if (isPast(date) && !isToday(date)) return 'text-red-600';
    if (isToday(date)) return 'text-orange-600';
    return 'text-gray-600';
  };

  const handleStartTimeBlock = () => {
    const now = new Date();
    const endTime = new Date(now.getTime() + (todo.estimatedDuration || 30) * 60000);
    
    addTimeBlock({
      todoId: todo.id,
      startTime: now,
      endTime,
      duration: todo.estimatedDuration || 30,
      completed: false
    });
  };

  return (
    <div className={`card p-4 border-l-4 ${getPriorityColor(todo.priority)} ${
      todo.completed ? 'opacity-75' : ''
    } transition-all duration-200 hover:shadow-md`}>
      <div className="flex items-start space-x-3">
        {/* Checkbox */}
        <button
          onClick={() => toggleTodo(todo.id)}
          className={`flex-shrink-0 w-5 h-5 rounded border-2 flex items-center justify-center transition-colors ${
            todo.completed
              ? 'bg-primary-600 border-primary-600 text-white'
              : 'border-gray-300 hover:border-primary-400'
          }`}
        >
          {todo.completed && <Check size={12} />}
        </button>

        {/* Content */}
        <div className="flex-1 min-w-0">
          <div className="flex items-start justify-between">
            <div className="flex-1">
              <h3 className={`font-medium ${
                todo.completed ? 'line-through text-gray-500' : 'text-gray-900'
              }`}>
                {todo.title}
              </h3>
              
              {todo.description && (
                <p className={`text-sm mt-1 ${
                  todo.completed ? 'text-gray-400' : 'text-gray-600'
                }`}>
                  {todo.description}
                </p>
              )}

              {/* Meta information */}
              <div className="flex items-center space-x-4 mt-2">
                {/* Category */}
                <div className="flex items-center space-x-1">
                  <span className="text-sm">{todo.category.icon}</span>
                  <span className="text-xs text-gray-500">{todo.category.name}</span>
                </div>

                {/* Priority */}
                <span className={`px-2 py-0.5 text-xs font-medium rounded-full ${getPriorityTextColor(todo.priority)} bg-opacity-10`}>
                  {todo.priority.charAt(0).toUpperCase() + todo.priority.slice(1)}
                </span>

                {/* Due Date */}
                {todo.dueDate && (
                  <div className="flex items-center space-x-1">
                    <Calendar size={12} className="text-gray-400" />
                    <span className={`text-xs ${getDueDateColor(todo.dueDate)}`}>
                      {formatDueDate(todo.dueDate)}
                    </span>
                  </div>
                )}

                {/* Estimated Duration */}
                {todo.estimatedDuration && (
                  <div className="flex items-center space-x-1">
                    <Clock size={12} className="text-gray-400" />
                    <span className="text-xs text-gray-500">
                      {todo.estimatedDuration}min
                    </span>
                  </div>
                )}
              </div>
            </div>

            {/* Actions */}
            <div className="flex items-center space-x-2">
              {!todo.completed && (
                <button
                  onClick={handleStartTimeBlock}
                  className="p-1 text-gray-400 hover:text-primary-600 hover:bg-primary-50 rounded transition-colors"
                  title="Start time block"
                >
                  <Play size={16} />
                </button>
              )}

              <div className="relative">
                <button
                  onClick={() => setShowOptions(!showOptions)}
                  className="p-1 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded transition-colors"
                >
                  <MoreHorizontal size={16} />
                </button>

                {showOptions && (
                  <>
                    {/* Backdrop */}
                    <div 
                      className="fixed inset-0 z-10"
                      onClick={() => setShowOptions(false)}
                    />
                    
                    {/* Dropdown */}
                    <div className="absolute right-0 top-8 z-20 bg-white rounded-lg shadow-lg border border-gray-200 py-1 min-w-[120px]">
                      <button
                        onClick={() => {
                          setShowOptions(false);
                          // TODO: Open edit modal
                        }}
                        className="w-full px-3 py-2 text-left text-sm text-gray-700 hover:bg-gray-100 flex items-center space-x-2"
                      >
                        <Edit size={14} />
                        <span>Edit</span>
                      </button>
                      
                      <button
                        onClick={() => {
                          setShowOptions(false);
                          deleteTodo(todo.id);
                        }}
                        className="w-full px-3 py-2 text-left text-sm text-red-600 hover:bg-red-50 flex items-center space-x-2"
                      >
                        <Trash2 size={14} />
                        <span>Delete</span>
                      </button>
                    </div>
                  </>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TodoItem;