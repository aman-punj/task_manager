# Task Manager (Flutter)

A clean and modern task management app built with Flutter, demonstrating scalable architecture, offline persistence, and polished Material 3 UI.

---

## Features

* Create, edit, and delete tasks
* Due date and time selection
* Validation to prevent past tasks
* Task status tracking (Completed / Pending)
* Filtering support

    * All
    * Completed
    * Pending
    * Overdue
* Offline-first using SQLite
* Material 3 UI with dark mode
* Smooth in-place state updates

---

## Architecture

This project follows a Clean Architecture approach:

```
lib/
├── core/         # Theme, utils, extensions, UI helpers
├── data/         # Models, datasources, repository impl
├── domain/       # Entities, repositories, filters
└── presentation/ # Bloc, screens, widgets
```

### Tech Stack

* State Management: flutter_bloc (BLoC pattern)
* Database: sqflite (SQLite)
* Theming: Material 3 + custom design tokens
* Fonts: Google Fonts (Inter)
* Architecture: Clean Architecture

---

## Design Decisions

### In-place State Updates

Instead of reloading all tasks after updates, the app performs in-memory state mutation to:

* Preserve active filters
* Improve perceived performance
* Reduce unnecessary database reads

### Design System

* Centralized AppColors
* Theme extensions on BuildContext
* Material 3 components
* Dark mode support

### UX Considerations

* Prevent creating tasks in the past
* Visual indicators for overdue tasks
* Filter-aware UI behavior

---

## Screens

| Screen        | Description                                   |
| ------------- | --------------------------------------------- |
| Task List     | View tasks with filters and status indicators |
| Add/Edit Task | Create or update tasks with date-time picker  |

---

## Getting Started

### Clone the repository

```bash
git clone https://github.com/aman-punj/task_manager.git
cd task_manager
```

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

---

## Dependencies

```yaml
flutter_bloc: ^8.x
sqflite: ^2.x
path: ^1.x
google_fonts: ^6.x
```

---

## Highlights

* Clean, interview-ready architecture
* Offline-first implementation
* Scalable filtering system
* Modern Material 3 styling
* Lightweight and performant

---

## Future Improvements

* Local notifications for due tasks
* Cloud sync (Firebase or Supabase)
* Analytics dashboard
* Search functionality
* Multi-platform support (Web/Desktop)

---

## Author

Aman
Flutter Developer

GitHub: [https://github.com/aman-punj](https://github.com/aman-punj)

---

## License

This project is open-source and available under the MIT License.
