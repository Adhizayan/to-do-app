export interface Todo {
  id: string;
  title: string;
  description?: string;
  completed: boolean;
  priority: Priority;
  category: Category;
  createdAt: Date;
  updatedAt: Date;
  dueDate?: Date;
  estimatedDuration?: number; // in minutes
  timeBlocks?: TimeBlock[];
}

export interface TimeBlock {
  id: string;
  todoId: string;
  startTime: Date;
  endTime: Date;
  duration: number; // in minutes
  completed: boolean;
}

export interface Category {
  id: string;
  name: string;
  color: string;
  icon?: string;
}

export type Priority = 'low' | 'medium' | 'high' | 'urgent';

export interface DaySchedule {
  date: Date;
  timeBlocks: TimeBlock[];
}

export interface TodoStats {
  totalTodos: number;
  completedTodos: number;
  totalTimeSpent: number; // in minutes
  averageCompletionTime: number; // in minutes
  productivityScore: number; // 0-100
}