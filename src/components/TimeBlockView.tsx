import React, { useState, useMemo } from 'react';
import { useTodo } from '../context/TodoContext';
import { format, startOfDay, addHours, isSameDay, addDays, subDays } from 'date-fns';
import { ChevronLeft, ChevronRight, Play, Pause, Check } from 'lucide-react';

const TimeBlockView: React.FC = () => {
  const { state, updateTimeBlock } = useTodo();
  const [currentDate, setCurrentDate] = useState(new Date());

  // Generate time slots for the day (7 AM to 10 PM)
  const timeSlots = useMemo(() => {
    const slots = [];
    const startHour = 7;
    const endHour = 22;
    
    for (let hour = startHour; hour <= endHour; hour++) {
      slots.push({
        time: addHours(startOfDay(currentDate), hour),
        label: format(addHours(startOfDay(currentDate), hour), 'h:mm a'),
      });
    }
    return slots;
  }, [currentDate]);

  // Get time blocks for the current date
  const todaysTimeBlocks = useMemo(() => {
    return state.timeBlocks.filter(block => 
      isSameDay(block.startTime, currentDate)
    );
  }, [state.timeBlocks, currentDate]);

  // Get todos for reference
  const todosMap = useMemo(() => {
    const map = new Map();
    state.todos.forEach(todo => {
      map.set(todo.id, todo);
    });
    return map;
  }, [state.todos]);

  const handlePreviousDay = () => {
    setCurrentDate(prev => subDays(prev, 1));
  };

  const handleNextDay = () => {
    setCurrentDate(prev => addDays(prev, 1));
  };

  const handleToday = () => {
    setCurrentDate(new Date());
  };

  const getTimeBlocksForSlot = (slotTime: Date) => {
    return todaysTimeBlocks.filter(block => {
      const blockHour = block.startTime.getHours();
      const slotHour = slotTime.getHours();
      return blockHour === slotHour;
    });
  };

  const handleToggleTimeBlock = (blockId: string) => {
    const block = state.timeBlocks.find(b => b.id === blockId);
    if (block) {
      updateTimeBlock(blockId, { completed: !block.completed });
    }
  };

  return (
    <div className="h-full flex flex-col bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 p-4">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Time Blocks</h2>
          
          <div className="flex items-center space-x-3">
            <button
              onClick={handlePreviousDay}
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <ChevronLeft size={20} className="text-gray-600" />
            </button>
            
            <button
              onClick={handleToday}
              className="px-3 py-1 text-sm font-medium text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
            >
              Today
            </button>
            
            <button
              onClick={handleNextDay}
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <ChevronRight size={20} className="text-gray-600" />
            </button>
          </div>
        </div>

        <div className="text-center">
          <h3 className="text-xl font-semibold text-gray-900">
            {format(currentDate, 'EEEE, MMMM d, yyyy')}
          </h3>
          <p className="text-sm text-gray-500">
            {todaysTimeBlocks.length} time blocks scheduled
          </p>
        </div>
      </div>

      {/* Time Blocks Grid */}
      <div className="flex-1 overflow-y-auto p-4">
        <div className="max-w-2xl mx-auto">
          <div className="space-y-2">
            {timeSlots.map((slot) => {
              const blocksInSlot = getTimeBlocksForSlot(slot.time);
              
              return (
                <div
                  key={slot.time.toISOString()}
                  className="flex items-start space-x-4 min-h-[60px]"
                >
                  {/* Time Label */}
                  <div className="w-20 flex-shrink-0 pt-2">
                    <div className="text-sm font-medium text-gray-500">
                      {slot.label}
                    </div>
                  </div>

                  {/* Time Blocks */}
                  <div className="flex-1">
                    {blocksInSlot.length === 0 ? (
                      <div className="h-14 border-2 border-dashed border-gray-200 rounded-lg flex items-center justify-center">
                        <span className="text-sm text-gray-400">No blocks scheduled</span>
                      </div>
                    ) : (
                      <div className="space-y-2">
                        {blocksInSlot.map((block) => {
                          const todo = todosMap.get(block.todoId);
                          if (!todo) return null;

                          return (
                            <div
                              key={block.id}
                              className={`card p-3 border-l-4 ${
                                block.completed 
                                  ? 'bg-green-50 border-green-500' 
                                  : 'bg-white border-primary-500'
                              }`}
                            >
                              <div className="flex items-center justify-between">
                                <div className="flex-1">
                                  <div className="flex items-center space-x-2">
                                    <span className="text-sm">{todo.category.icon}</span>
                                    <h4 className={`font-medium ${
                                      block.completed ? 'line-through text-gray-500' : 'text-gray-900'
                                    }`}>
                                      {todo.title}
                                    </h4>
                                  </div>
                                  
                                  <div className="flex items-center space-x-4 mt-1">
                                    <span className="text-xs text-gray-500">
                                      {format(block.startTime, 'h:mm a')} - {format(block.endTime, 'h:mm a')}
                                    </span>
                                    <span className="text-xs text-gray-500">
                                      {block.duration}min
                                    </span>
                                    <span className={`px-2 py-0.5 text-xs font-medium rounded-full ${
                                      todo.priority === 'urgent' ? 'bg-red-100 text-red-700' :
                                      todo.priority === 'high' ? 'bg-orange-100 text-orange-700' :
                                      todo.priority === 'medium' ? 'bg-yellow-100 text-yellow-700' :
                                      'bg-green-100 text-green-700'
                                    }`}>
                                      {todo.priority}
                                    </span>
                                  </div>
                                </div>

                                <button
                                  onClick={() => handleToggleTimeBlock(block.id)}
                                  className={`p-2 rounded-lg transition-colors ${
                                    block.completed
                                      ? 'bg-green-100 text-green-600 hover:bg-green-200'
                                      : 'bg-primary-100 text-primary-600 hover:bg-primary-200'
                                  }`}
                                >
                                  {block.completed ? <Check size={16} /> : <Play size={16} />}
                                </button>
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* Summary */}
      <div className="bg-white border-t border-gray-200 p-4">
        <div className="max-w-2xl mx-auto">
          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <div className="text-lg font-semibold text-gray-900">
                {todaysTimeBlocks.length}
              </div>
              <div className="text-sm text-gray-500">Total Blocks</div>
            </div>
            <div>
              <div className="text-lg font-semibold text-green-600">
                {todaysTimeBlocks.filter(b => b.completed).length}
              </div>
              <div className="text-sm text-gray-500">Completed</div>
            </div>
            <div>
              <div className="text-lg font-semibold text-primary-600">
                {todaysTimeBlocks.reduce((sum, block) => sum + block.duration, 0)}min
              </div>
              <div className="text-sm text-gray-500">Total Time</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TimeBlockView;