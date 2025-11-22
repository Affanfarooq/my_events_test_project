# MyEvents - Flutter Technical Task

A realistic, production-grade cross-platform Flutter application for browsing, creating, and managing events. Built with **Clean Architecture** and **Offline-First** principles.

## Features
* **Authentication:** Login/Signup with tabbed UI and validation.
* **Events Feed:** Paginated list with infinite scroll, pull-to-refresh, and modern shimmer loading.
* **Event Details:** Immersive UI with Hero animations, organizer info, and interactive map visualization.
* **Create/Edit:** Form with validation, date picker, and image picker (Camera/Gallery).
* **Offline Support:** Full offline caching using Hive. Visual "Offline Mode" banner when disconnected.
* **Favorites:** Local toggle for favorite events.

## Tech Stack & Architecture

### Architecture: Clean Architecture
The project is strictly divided into layers to ensure separation of concerns and testability:
* **Presentation:** UI (Widgets) and State Management (GetX Controllers).
* **Domain:** Business Logic (Entities, UseCases, Repository Interfaces).
* **Data:** Data retrieval (Models, DataSources, Repository Implementations).

### State Management: GetX
**Justification:** I chose GetX for this task because it provides a unified, lightweight solution for:
1.  **State Management:** Reactive variables (`.obs`) make UI updates efficient.
2.  **Dependency Injection:** Simple service locator (`Get.put`/`Get.find`) without context.
3.  **Routing:** Named routes (`Get.toNamed`) and parameter handling.
This reduced boilerplate significantly compared to BLoC/Provider for this specific scope.

### Key Packages
* **Networking:** `dio` (with custom Interceptors for logging).
* **Local Storage:** `hive` & `hive_flutter` (NoSQL DB for high-performance caching).
* **Secure Storage:** `flutter_secure_storage` (For JWT tokens).
* **UI:** `cached_network_image`, `shimmer`, `lottie` (Splash), `image_picker`.
* **Utils:** `connectivity_plus`, `intl`, `flutter_dotenv`.

## Setup & Run

1.  **Clone the repository:**
    git clone https://github.com/Affanfarooq/my_events_test_project

2.  **Install Dependencies:**
    flutter pub get

3.  **Environment Setup:**
    Create a `.env` file in the root directory:
    REQRES_BASE_URL=[https://reqres.in/api](https://reqres.in/api)
    MOCKAPI_BASE_URL=[https://691cdaa4xxxxxxxxxxxx.mockapi.io](https://691cdaa4xxxxxxxxxxxxxxxxx.mockapi.io)

4.  **Run the App:**
    flutter run

##  Testing
Unit tests are implemented for the Authentication Repository using `mockito`.
To run tests:
```bash
flutter test



##  AI & Tools Disclosure
* In compliance with the task requirements, the following AI tools and resources were utilized to assist in development:
* **Google Gemini:** Used as a pair programmer for:
    * Generating Clean Architecture boilerplate (Data/Domain layers).
    * Debugging specific API errors (e.g., `401` Auth headers).
    * Refining UI aesthetics (Gradients and Shadow configurations).
* **MockAPI.io:** Used to host the custom REST API for Events (CRUD operations).
* **ReqRes.in:** Used as the mock authentication provider.


##  Notes for Reviewer
* **Map Implementation:** Due to time constraints and API key requirements, the map view uses a high-quality static image placeholder with a functional "Open in Maps" intent.
* **Image Upload:** Since MockAPI does not support file storage, image upload is simulated in the Data Source (returns a random Picsum URL).
* **Multiple Images:** The requirement specified multiple image attachments. However, due to the constraints of the MockAPI schema and to focus on core architecture quality within the deadline, I implemented a **Single Cover Image** flow.
* **Optimistic UI:** The app uses optimistic updates for Create/Edit events to make the UI feel instant, syncing with the API in the background.