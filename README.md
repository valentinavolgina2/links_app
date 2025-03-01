# My Links

A full-stack Flutter application that helps users organize links effortlessly with customizable categories and tags for quick filtering. The application is deployed to Firebase and utilizes Firebase Realtime Database as the main storage.

## Features

### 1. Link Organization
Users can save and categorize links into customizable categories, making navigation and access to saved content seamless.

### 2. Tagging System
Each link can be tagged with keywords, allowing users to filter and search for specific content quickly and effectively.

### 3. Photo Upload
Supports uploading photos for each list of links, providing visual context and enhancing user experience.

### 4. Authentication Options
Implemented Google Sign-In and standard email/password authentication to ensure secure access and personalized user accounts.

### 5. Firebase Integration
Leveraged Firebase services, including Firebase Authentication and Realtime Database, to power the backend infrastructure, enabling seamless data synchronization and real-time updates across devices.

## Installation

### Prerequisites
- Install [Flutter](https://flutter.dev/docs/get-started/install)
- Ensure that you have a Firebase project set up ([Firebase Console](https://console.firebase.google.com/))
- Clone this repository:
  ```sh
  git clone https://github.com/yourusername/my-links.git
  cd my-links
  ```
- Install dependencies:
  ```sh
  flutter pub get
  ```
- Set up Firebase by adding `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the project.

### Run the Application
To start the application, run:
```sh
flutter run
```

## Dependencies
The project utilizes the following dependencies:

```yaml
  dependencies:
    flutter:
      sdk: flutter

    cupertino_icons: ^1.0.2
    url_launcher: ^6.1.7
    path: ^1.8.2
    firebase_database: ^10.1.1
    firebase_core: ^2.14.0
    firebase_auth: ^4.5.0
    shared_preferences: ^2.1.1
    google_sign_in: ^6.1.0
    string_validator: ^1.0.0
    textfield_tags: ^2.0.2
    flutter_facebook_auth: ^5.0.11
    firebase_storage: ^11.2.3
    cloud_firestore: ^4.8.1
    image_picker: ^0.8.9
    mime_type: ^1.0.0
```

## Deployment
The project is deployed to Firebase Hosting at:
**[links-app-d361f.web.app](https://links-app-d361f.web.app/)**


