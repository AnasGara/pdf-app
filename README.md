# PDF Reader Pro

A production-ready Flutter PDF Reader application built with Clean Architecture, Material 3, and optimized for Android 15 (API Level 36).

## Features

- **Advanced PDF Viewer**: Smooth scrolling, pinch-to-zoom, double-tap zoom.
- **Search**: Fast text search within PDF documents with match highlighting.
- **Bookmarks**: Save and manage bookmarks to quickly navigate through documents.
- **Recent Files**: Automatically tracks recently opened documents with reading progress.
- **Favorites**: Mark documents as favorites for quick access.
- **Reading Progress**: Automatically saves the last opened page and percentage.
- **Dark Mode**: Supports light, dark, and system themes using Material 3.
- **Privacy First**: Works completely offline, no tracking, no data collection.
- **Modern Architecture**: Built using Clean Architecture with Provider for state management.

## Technical Stack

- **Flutter**: 3.44.1
- **State Management**: Provider
- **Database**: SQLite (sqflite)
- **PDF Engine**: Syncfusion Flutter PDF Viewer
- **Target SDK**: Android API Level 36 (Android 15+)

## Project Structure

```text
lib/
├── core/           # Core constants and utilities
├── models/         # Data models (PdfDocument, Bookmark, etc.)
├── services/       # External services (FilePicker, SharedPreferences)
├── repositories/   # Data abstraction layer
├── providers/      # State management
├── screens/        # UI Screens (Home, Reader, Settings)
├── widgets/        # Reusable UI components
├── database/       # SQLite database helper
└── main.dart       # App entry point
```

## Getting Started

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/anasgara/pdf-reader-pro.git
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## Permissions

The app requires minimal permissions to function:
- `READ_EXTERNAL_STORAGE` (up to Android 12)
- Scoped Storage / Storage Access Framework (Android 13+)

## License

This project is licensed under the MIT License.
