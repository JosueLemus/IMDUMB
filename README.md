# IMDUMB

A Flutter movie application demonstrating **Clean Architecture**, **SOLID principles**, and **production-grade practices**. This project fulfills the technical challenge requirements for a Senior Flutter Developer profile.

---

## 📋 Project Overview

**IMDUMB** is a movie discovery app that showcases diverse technical capabilities:
- **Architecture**: Strict Clean Architecture (Presentation, Domain, Data).
- **State Management**: BLoC implementation with `bloc_concurrency` for event transformation.
- **Networking**: Dio with custom Interceptors and error handling.
- **Environments**: Configured flavors for **QA** and **Production**.
- **Firebase Integration**: Remote Config for dynamic theming, Analytics for user behavior, and Firestore for managing user recommendations.

---

## 🏗️ Architecture

The project follows a rigorous **Clean Architecture** to ensure separation of concerns, testability, and scalability.

```
lib/
├── core/                    # Cross-cutting concerns
│   ├── bloc/                # Global BlocObserver
│   ├── config/              # Environment configuration (Env)
│   ├── di/                  # Dependency Injection (GetIt)
│   ├── network/             # Dio client & Interceptors
│   ├── router/              # Navigation (GoRouter)
│   ├── services/            # Third-party services (RemoteConfig, Theme)
│   └── theme/               # App Design System
│
├── features/
│   ├── home/                # Movie Categories (Genres)
│   │   ├── presentation/    # HomeBloc, Pages
│   │
│   ├── movie/               # Core Movie Logic
│   │   ├── data/            # DTOs, DataSources (Remote/Local), Repositories Impl
│   │   ├── domain/          # Entities, Repositories Contracts, UseCases
│   │   └── presentation/    # GenreMoviesBloc, MovieDetailsCubit, UI
│   │
│   └── splash/              # App Initialization & Data Pre-fetching
```

### Layer Responsibilities

1.  **Domain Layer (Inner Core)**: Contains pure Dart code. Entities, Repository Interfaces, and Use Cases. It has **zero dependencies** on Flutter or external libraries.
2.  **Data Layer**: Implements Repository interfaces. Handles data retrieval from APIs (Dio) or Local Storage (Hive), and mapping to Domain Entities.
3.  **Presentation Layer**: UI (Widgets) and State Management (BLoC/Cubit). It depends only on the Domain Layer.

---

## ✨ Key Features & Implementation Details

### 🔄 State Management (BLoC)
We utilize the **BLoC pattern** for complex flows and **Cubit** for simpler states.
- **Advanced Event Handling**: Usage of `bloc_concurrency`'s `droppable` transformer in `GenreMoviesBloc` to prevent duplicate API requests during pagination (throttling).
- **Global Monitoring**: Implementation of `AppBlocObserver` to log all state changes and errors for debugging.

### 🌍 Environments (Flavors)
The app is configured with two distinct flavors, each with its own Firebase project, bundle ID, and environment variables:
- **QA**: `com.example.imdumb.qa` (Orange Banner, Debug logging enabled)
- **Production**: `com.example.imdumb` (Clean UI, Production analytics)

This was achieved using `flutter_flavorizr` and custom entry points (`main_qa.dart`, `main_prod.dart`).

### 🔥 Firebase Integration
- **Remote Config**: Fetches dynamic theme colors (`primary_color`) at app startup.
- **Analytics**: Tracks key events like `recommend_movie` and user segmentation by environment (`env` user property).
- **Firestore**: Implements a full **CRUD** for User Recommendations (Create, Read, Delete) directly from the detailed view.

### 💾 Local Persistence
- **Hive**: Used to cache critical data like Movie Genres to ensure the app works offline or loads instantly on subsequent launches.

---

## � Demo Preview

### 1. 🔄 Infinite Scroll & Concurrency
*Implementing `droppable` transformer to prevent duplicate API calls.*
<!-- Add your GIF/Video here showing the smooth scroll -->
![Pagination Demo](placeholder_link)

### 2. 🎨 Dynamic Theming (Remote Config)
*Fetching specific theme colors from Firebase.*
<!-- Add your GIF/Video here showing the splash screen loading the theme -->
![Theme Demo](placeholder_link)

### 3. 📝 User Recommendations (Firestore)
*Real-time CRUD operations.*
<!-- Add your GIF/Video here showing the create/delete flow -->
![CRUD Demo](placeholder_link)

### 4. 🌍 QA vs Prod Environments
*Distinct features for each flavor.*
<!-- Add your GIF/Video here showing the different apps -->
![Environments Demo](placeholder_link)

---

## �🏛️ SOLID Principles in Action

Specific examples of SOLID principles documented in the code:

1.  **Single Responsibility Principle (SRP)**:
    - *Example*: `MovieRemoteDataSource` handles **only** raw data fetching, while `MovieRepositoryImpl` maps those models to domain entities.
2.  **Open/Closed Principle (OCP)**:
    - *Example*: The `DioClient` is open for extension (adding new interceptors) but closed for modification. We add `LoggingInterceptor` and `ErrorInterceptor` without changing the client's core logic.
3.  **Dependency Inversion Principle (DIP)**:
    - *Example*: The Presentation layer depends on abstract `UseCases` and `Repository` interfaces (Domain), not concrete implementations (Data). All dependencies are injected via `GetIt` (`injection_container.dart`).

---

## 🚀 Setup & Execution

### Prerequisites
- Flutter SDK: `>=3.10.8`
- Dart SDK: `>=3.0.0`
- Active Firebase Project (google-services.json required)

### Installation
```bash
# Clone the repository
git clone <repo_url>
cd imdumb

# Install dependencies
flutter pub get
```

### Running the App
Since the project uses flavors, you **must** specify the flavor and entry point:

**Run QA Environment:**
```bash
flutter run --flavor qa -t lib/main_qa.dart
```

**Run Production Environment:**
```bash
flutter run --flavor prod -t lib/main_prod.dart
```

### Note on Secrets
The project requires `.env.qa` and `.env.prod` files in the root directory.
```env
# .env.qa / .env.prod
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_ACCESS_TOKEN=your_api_token_here
```

---

## 📦 Tech Stack

- **Core**: Flutter, Dart
- **State**: `flutter_bloc`, `bloc_concurrency`, `equatable`
- **Navigation**: `go_router`
- **Networking**: `dio`
- **DI**: `get_it`
- **Storage**: `hive`, `hive_flutter`
- **Firebase**: `firebase_core`, `cloud_firestore`, `firebase_remote_config`, `firebase_analytics`
- **UI Tooling**: `cached_network_image`, `shimmer`, `carousel_slider_plus`

---
*Developed by Josue Lemus - 2026*
