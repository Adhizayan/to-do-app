import React, { createContext, useContext, useReducer, ReactNode, useEffect } from 'react';
import { Todo, TimeBlock, Category, Priority } from '../types';
import { v4 as uuidv4 } from 'uuid';

// Default categories
const defaultCategories: Category[] = [
  { id: 'work', name: 'Work', color: '#3B82F6', icon: '💼' },
  { id: 'personal', name: 'Personal', color: '#10B981', icon: '👤' },
  { id: 'health', name: 'Health', color: '#F59E0B', icon: '🏃‍♂️' },
  { id: 'learning', name: 'Learning', color: '#8B5CF6', icon: '📚' },
];

interface TodoState {
  todos: Todo[];
  categories: Category[];
  timeBlocks: TimeBlock[];
  selectedDate: Date;
}

type TodoAction =
  | { type: 'ADD_TODO'; payload: Omit<Todo, 'id' | 'createdAt' | 'updatedAt'> }
  | { type: 'UPDATE_TODO'; payload: { id: string; updates: Partial<Todo> } }
  | { type: 'DELETE_TODO'; payload: string }
  | { type: 'TOGGLE_TODO'; payload: string }
  | { type: 'ADD_TIME_BLOCK'; payload: Omit<TimeBlock, 'id'> }
  | { type: 'UPDATE_TIME_BLOCK'; payload: { id: string; updates: Partial<TimeBlock> } }
  | { type: 'DELETE_TIME_BLOCK'; payload: string }
  | { type: 'ADD_CATEGORY'; payload: Omit<Category, 'id'> }
  | { type: 'UPDATE_CATEGORY'; payload: { id: string; updates: Partial<Category> } }
  | { type: 'DELETE_CATEGORY'; payload: string }
  | { type: 'SET_SELECTED_DATE'; payload: Date }
  | { type: 'LOAD_DATA'; payload: TodoState };

const initialState: TodoState = {
  todos: [],
  categories: defaultCategories,
  timeBlocks: [],
  selectedDate: new Date(),
};

function todoReducer(state: TodoState, action: TodoAction): TodoState {
  switch (action.type) {
    case 'ADD_TODO': {
      const newTodo: Todo = {
        ...action.payload,
        id: uuidv4(),
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      return { ...state, todos: [...state.todos, newTodo] };
    }
    
    case 'UPDATE_TODO': {
      return {
        ...state,
        todos: state.todos.map(todo =>
          todo.id === action.payload.id
            ? { ...todo, ...action.payload.updates, updatedAt: new Date() }
            : todo
        ),
      };
    }
    
    case 'DELETE_TODO': {
      return {
        ...state,
        todos: state.todos.filter(todo => todo.id !== action.payload),
        timeBlocks: state.timeBlocks.filter(block => block.todoId !== action.payload),
      };
    }
    
    case 'TOGGLE_TODO': {
      return {
        ...state,
        todos: state.todos.map(todo =>
          todo.id === action.payload
            ? { ...todo, completed: !todo.completed, updatedAt: new Date() }
            : todo
        ),
      };
    }
    
    case 'ADD_TIME_BLOCK': {
      const newTimeBlock: TimeBlock = {
        ...action.payload,
        id: uuidv4(),
      };
      return { ...state, timeBlocks: [...state.timeBlocks, newTimeBlock] };
    }
    
    case 'UPDATE_TIME_BLOCK': {
      return {
        ...state,
        timeBlocks: state.timeBlocks.map(block =>
          block.id === action.payload.id
            ? { ...block, ...action.payload.updates }
            : block
        ),
      };
    }
    
    case 'DELETE_TIME_BLOCK': {
      return {
        ...state,
        timeBlocks: state.timeBlocks.filter(block => block.id !== action.payload),
      };
    }
    
    case 'ADD_CATEGORY': {
      const newCategory: Category = {
        ...action.payload,
        id: uuidv4(),
      };
      return { ...state, categories: [...state.categories, newCategory] };
    }
    
    case 'UPDATE_CATEGORY': {
      return {
        ...state,
        categories: state.categories.map(category =>
          category.id === action.payload.id
            ? { ...category, ...action.payload.updates }
            : category
        ),
      };
    }
    
    case 'DELETE_CATEGORY': {
      return {
        ...state,
        categories: state.categories.filter(category => category.id !== action.payload),
      };
    }
    
    case 'SET_SELECTED_DATE': {
      return { ...state, selectedDate: action.payload };
    }
    
    case 'LOAD_DATA': {
      return action.payload;
    }
    
    default:
      return state;
  }
}

interface TodoContextType {
  state: TodoState;
  addTodo: (todo: Omit<Todo, 'id' | 'createdAt' | 'updatedAt'>) => void;
  updateTodo: (id: string, updates: Partial<Todo>) => void;
  deleteTodo: (id: string) => void;
  toggleTodo: (id: string) => void;
  addTimeBlock: (timeBlock: Omit<TimeBlock, 'id'>) => void;
  updateTimeBlock: (id: string, updates: Partial<TimeBlock>) => void;
  deleteTimeBlock: (id: string) => void;
  addCategory: (category: Omit<Category, 'id'>) => void;
  updateCategory: (id: string, updates: Partial<Category>) => void;
  deleteCategory: (id: string) => void;
  setSelectedDate: (date: Date) => void;
}

const TodoContext = createContext<TodoContextType | undefined>(undefined);

export function TodoProvider({ children }: { children: ReactNode }) {
  const [state, dispatch] = useReducer(todoReducer, initialState);

  // Load data from localStorage on mount
  useEffect(() => {
    const savedData = localStorage.getItem('todo-app-data');
    if (savedData) {
      try {
        const parsedData = JSON.parse(savedData);
        // Convert date strings back to Date objects
        const processedData = {
          ...parsedData,
          todos: parsedData.todos.map((todo: any) => ({
            ...todo,
            createdAt: new Date(todo.createdAt),
            updatedAt: new Date(todo.updatedAt),
            dueDate: todo.dueDate ? new Date(todo.dueDate) : undefined,
          })),
          timeBlocks: parsedData.timeBlocks.map((block: any) => ({
            ...block,
            startTime: new Date(block.startTime),
            endTime: new Date(block.endTime),
          })),
          selectedDate: new Date(parsedData.selectedDate),
        };
        dispatch({ type: 'LOAD_DATA', payload: processedData });
      } catch (error) {
        console.error('Error loading saved data:', error);
      }
    }
  }, []);

  // Save data to localStorage whenever state changes
  useEffect(() => {
    localStorage.setItem('todo-app-data', JSON.stringify(state));
  }, [state]);

  const contextValue: TodoContextType = {
    state,
    addTodo: (todo) => dispatch({ type: 'ADD_TODO', payload: todo }),
    updateTodo: (id, updates) => dispatch({ type: 'UPDATE_TODO', payload: { id, updates } }),
    deleteTodo: (id) => dispatch({ type: 'DELETE_TODO', payload: id }),
    toggleTodo: (id) => dispatch({ type: 'TOGGLE_TODO', payload: id }),
    addTimeBlock: (timeBlock) => dispatch({ type: 'ADD_TIME_BLOCK', payload: timeBlock }),
    updateTimeBlock: (id, updates) => dispatch({ type: 'UPDATE_TIME_BLOCK', payload: { id, updates } }),
    deleteTimeBlock: (id) => dispatch({ type: 'DELETE_TIME_BLOCK', payload: id }),
    addCategory: (category) => dispatch({ type: 'ADD_CATEGORY', payload: category }),
    updateCategory: (id, updates) => dispatch({ type: 'UPDATE_CATEGORY', payload: { id, updates } }),
    deleteCategory: (id) => dispatch({ type: 'DELETE_CATEGORY', payload: id }),
    setSelectedDate: (date) => dispatch({ type: 'SET_SELECTED_DATE', payload: date }),
  };

  return (
    <TodoContext.Provider value={contextValue}>
      {children}
    </TodoContext.Provider>
  );
}

export function useTodo() {
  const context = useContext(TodoContext);
  if (context === undefined) {
    throw new Error('useTodo must be used within a TodoProvider');
  }
  return context;
}