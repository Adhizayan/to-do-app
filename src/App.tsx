import React, { useState } from 'react';
import { TodoProvider } from './context/TodoContext';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import TodoList from './components/TodoList';
import TimeBlockView from './components/TimeBlockView';
import StatsPanel from './components/StatsPanel';

type ViewMode = 'todos' | 'calendar' | 'stats';

function App() {
  const [viewMode, setViewMode] = useState<ViewMode>('todos');
  const [sidebarOpen, setSidebarOpen] = useState(true);

  const renderMainContent = () => {
    switch (viewMode) {
      case 'todos':
        return <TodoList />;
      case 'calendar':
        return <TimeBlockView />;
      case 'stats':
        return <StatsPanel />;
      default:
        return <TodoList />;
    }
  };

  return (
    <TodoProvider>
      <div className="h-screen bg-gray-50 flex">
        {/* Sidebar */}
        <div className={`${sidebarOpen ? 'w-80' : 'w-0'} transition-all duration-300 overflow-hidden`}>
          <Sidebar onViewModeChange={setViewMode} currentView={viewMode} />
        </div>

        {/* Main Content */}
        <div className="flex-1 flex flex-col">
          {/* Header */}
          <Header 
            onToggleSidebar={() => setSidebarOpen(!sidebarOpen)}
            sidebarOpen={sidebarOpen}
          />

          {/* Main Content Area */}
          <div className="flex-1 overflow-hidden">
            {renderMainContent()}
          </div>
        </div>
      </div>
    </TodoProvider>
  );
}

export default App;