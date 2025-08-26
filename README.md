# TaskFlow - Time-Blocking Todo App

A modern, productivity-focused task management application with time-blocking functionality to help users structure their daily planning and boost productivity.

## ✨ Features

### 📋 Task Management
- Create, edit, and delete tasks with rich metadata
- Set priorities (Low, Medium, High, Urgent)
- Organize tasks by categories (Work, Personal, Health, Learning)
- Add due dates and estimated durations
- Mark tasks as complete with visual feedback

### ⏰ Time-Blocking
- Schedule tasks into specific time blocks
- Visual calendar view with hourly slots (7 AM - 10 PM)
- Start and complete time blocks with one-click
- Track actual time spent on tasks
- Navigate between different days

### 📊 Analytics & Insights
- Comprehensive productivity statistics
- Completion rates and trends
- Priority and category breakdowns
- Time spent analysis
- Intelligent recommendations and insights
- Productivity score calculation

### 🎨 Modern UI/UX
- Clean, intuitive interface built with Tailwind CSS
- Responsive design for all screen sizes
- Smooth animations and transitions
- Color-coded priority system
- Dark/light theme support

### 💾 Data Persistence
- Automatic local storage of all data
- No server required - works offline
- Import/export functionality (future enhancement)

## 🚀 Getting Started

### Prerequisites
- Node.js (version 16 or higher)
- npm or yarn package manager

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/todo-app-time-blocking.git
cd todo-app-time-blocking
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```

4. Open your browser and navigate to `http://localhost:3000`

### Building for Production

```bash
npm run build
```

The built files will be in the `dist` directory.

## 📱 How to Use

### Creating Tasks
1. Click the "Add New Task" button in the sidebar or header
2. Fill in the task details:
   - **Title**: Brief description of the task
   - **Description**: Additional details (optional)
   - **Priority**: Set urgency level
   - **Category**: Organize by type
   - **Due Date**: Set deadline (optional)
   - **Duration**: Estimated time to complete

### Time-Blocking
1. Navigate to the "Time Blocks" view
2. Click the play button on any task to create a time block
3. Time blocks appear in the calendar view
4. Click the play/check button to start/complete blocks
5. Use navigation controls to view different days

### Viewing Analytics
1. Go to the "Analytics" tab
2. Review your productivity metrics:
   - Overall completion rates
   - Time spent analysis
   - Priority distribution
   - Category performance
   - Weekly progress

## 🛠️ Technical Stack

- **Frontend**: React 18 with TypeScript
- **Styling**: Tailwind CSS
- **State Management**: React Context API with useReducer
- **Icons**: Lucide React
- **Date Handling**: date-fns
- **Build Tool**: Vite
- **Development**: ESLint, TypeScript

## 📁 Project Structure

```
src/
├── components/         # React components
│   ├── Header.tsx     # Top navigation bar
│   ├── Sidebar.tsx    # Left navigation panel
│   ├── TodoList.tsx   # Task list view
│   ├── TodoItem.tsx   # Individual task component
│   ├── AddTodoModal.tsx # Task creation modal
│   ├── TimeBlockView.tsx # Calendar/time-blocking view
│   └── StatsPanel.tsx # Analytics dashboard
├── context/           # State management
│   └── TodoContext.tsx # Global app state
├── types/             # TypeScript definitions
│   └── index.ts       # App-wide type definitions
├── App.tsx            # Main application component
├── main.tsx           # Application entry point
└── index.css          # Global styles
```

## 🎯 Key Features Explained

### Time-Blocking Methodology
Time-blocking is a time management technique where you divide your day into distinct blocks of time, each dedicated to specific tasks or groups of tasks. This app implements this methodology by:

- Allowing users to schedule tasks into specific time slots
- Providing visual feedback on time allocation
- Tracking actual vs. estimated time
- Encouraging focused work sessions

### Productivity Analytics
The analytics features help users understand their work patterns:

- **Completion Rate**: Percentage of tasks completed
- **Productivity Score**: Algorithm-based score considering completion rate, time-blocking usage, and priority management
- **Category Performance**: Shows which areas need more attention
- **Time Analysis**: Tracks how much time is actually spent on different types of work

## 🔮 Future Enhancements

- [ ] Drag-and-drop time block scheduling
- [ ] Recurring task templates
- [ ] Team collaboration features
- [ ] Mobile app (React Native)
- [ ] Calendar integration (Google Calendar, Outlook)
- [ ] Advanced reporting and exports
- [ ] Pomodoro timer integration
- [ ] Goal setting and tracking
- [ ] Email reminders and notifications

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Time-blocking methodology inspired by productivity experts like Cal Newport
- UI/UX design principles from modern productivity apps
- React and TypeScript community for excellent tooling
- Tailwind CSS for the utility-first styling approach

---

**Built with ❤️ for productivity enthusiasts**
