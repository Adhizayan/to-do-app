import React, { useState } from 'react';
import { useTodo } from '../context/TodoContext';
import { Priority } from '../types';
import { X, Calendar, Clock, Tag } from 'lucide-react';

interface AddTodoModalProps {
  onClose: () => void;
}

const AddTodoModal: React.FC<AddTodoModalProps> = ({ onClose }) => {
  const { addTodo, state } = useTodo();
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    priority: 'medium' as Priority,
    categoryId: state.categories[0]?.id || '',
    dueDate: '',
    estimatedDuration: 30,
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!formData.title.trim()) return;

    const selectedCategory = state.categories.find(c => c.id === formData.categoryId) || state.categories[0];
    
    addTodo({
      title: formData.title.trim(),
      description: formData.description.trim() || undefined,
      completed: false,
      priority: formData.priority,
      category: selectedCategory,
      dueDate: formData.dueDate ? new Date(formData.dueDate) : undefined,
      estimatedDuration: formData.estimatedDuration || undefined,
    });

    onClose();
  };

  const handleBackdropClick = (e: React.MouseEvent) => {
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  return (
    <div 
      className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
      onClick={handleBackdropClick}
    >
      <div className="bg-white rounded-xl shadow-xl w-full max-w-md">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-gray-200">
          <h2 className="text-lg font-semibold text-gray-900">Add New Task</h2>
          <button
            onClick={onClose}
            className="p-1 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded transition-colors"
          >
            <X size={20} />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          {/* Title */}
          <div>
            <label htmlFor="title" className="block text-sm font-medium text-gray-700 mb-1">
              Title *
            </label>
            <input
              type="text"
              id="title"
              value={formData.title}
              onChange={(e) => setFormData(prev => ({ ...prev, title: e.target.value }))}
              className="input-field"
              placeholder="Enter task title..."
              required
              autoFocus
            />
          </div>

          {/* Description */}
          <div>
            <label htmlFor="description" className="block text-sm font-medium text-gray-700 mb-1">
              Description
            </label>
            <textarea
              id="description"
              value={formData.description}
              onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
              className="input-field resize-none"
              rows={3}
              placeholder="Add more details..."
            />
          </div>

          {/* Priority and Category Row */}
          <div className="grid grid-cols-2 gap-4">
            {/* Priority */}
            <div>
              <label htmlFor="priority" className="block text-sm font-medium text-gray-700 mb-1">
                Priority
              </label>
              <select
                id="priority"
                value={formData.priority}
                onChange={(e) => setFormData(prev => ({ ...prev, priority: e.target.value as Priority }))}
                className="input-field"
              >
                <option value="low">Low</option>
                <option value="medium">Medium</option>
                <option value="high">High</option>
                <option value="urgent">Urgent</option>
              </select>
            </div>

            {/* Category */}
            <div>
              <label htmlFor="category" className="block text-sm font-medium text-gray-700 mb-1">
                Category
              </label>
              <select
                id="category"
                value={formData.categoryId}
                onChange={(e) => setFormData(prev => ({ ...prev, categoryId: e.target.value }))}
                className="input-field"
              >
                {state.categories.map(category => (
                  <option key={category.id} value={category.id}>
                    {category.icon} {category.name}
                  </option>
                ))}
              </select>
            </div>
          </div>

          {/* Due Date and Duration Row */}
          <div className="grid grid-cols-2 gap-4">
            {/* Due Date */}
            <div>
              <label htmlFor="dueDate" className="block text-sm font-medium text-gray-700 mb-1">
                <Calendar size={14} className="inline mr-1" />
                Due Date
              </label>
              <input
                type="date"
                id="dueDate"
                value={formData.dueDate}
                onChange={(e) => setFormData(prev => ({ ...prev, dueDate: e.target.value }))}
                className="input-field"
                min={new Date().toISOString().split('T')[0]}
              />
            </div>

            {/* Estimated Duration */}
            <div>
              <label htmlFor="duration" className="block text-sm font-medium text-gray-700 mb-1">
                <Clock size={14} className="inline mr-1" />
                Duration (min)
              </label>
              <input
                type="number"
                id="duration"
                value={formData.estimatedDuration}
                onChange={(e) => setFormData(prev => ({ ...prev, estimatedDuration: parseInt(e.target.value) || 0 }))}
                className="input-field"
                min="5"
                max="480"
                step="5"
                placeholder="30"
              />
            </div>
          </div>

          {/* Actions */}
          <div className="flex space-x-3 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 btn-secondary"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="flex-1 btn-primary"
              disabled={!formData.title.trim()}
            >
              Add Task
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AddTodoModal;