# 📱 We Chat

A real-time Flutter chat app built using **Flutter & Dart**, with **Firebase Authentication**, **Cloud Firestore**, and **Firebase Cloud Messaging**. Designed with a clean and beautiful UI for a seamless user experience. Users can sign up, sign in, and send messages to each other instantly!

---

## ✨ Features

- 🔒 **User Authentication**
  - Sign up & log in using email and password via Firebase Auth
  - Securely store user profile info: username, email, and profile image

- 💬 **Real-Time Messaging**
  - Send and receive messages instantly using Cloud Firestore
  - Automatically scroll to new messages

- 🔔 **Push Notifications**
  - Firebase Cloud Messaging with topic-based subscription (`chat` topic)
  - Notifications sent to users when new messages arrive

- 🌐 **Firestore Data Storage**
  - User data and messages are stored and retrieved in real-time from Cloud Firestore

- 🎨 **Beautiful UI**
  - Smooth animations
  - Clean layout
  - Optimized for a great user experience

---

## 🛠️ Tech Stack

- **Flutter & Dart**
- **Firebase Auth**
- **Cloud Firestore**
- **Firebase Cloud Messaging**

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed
- Firebase project created
- Android/iOS setup done (with `google-services.json` or `GoogleService-Info.plist` added)

### Setup Instructions

```bash
git clone https://github.com/Siddiqui145/we_chat.git
cd we_chat
flutter pub get
```

- Set up Firebase for Android and iOS
- Enable Firebase Authentication (Email/Password)
- Create Firestore database
- Enable Firebase Cloud Messaging
- Update Firebase config files in your project

---

## 🔐 Firebase Configuration

Make sure to:
- Add Firebase to your Flutter project
- Configure FCM topic subscription logic
- Enable necessary permissions in `AndroidManifest.xml` and `Info.plist`

---

## 📂 Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── login_screen.dart
│   ├── chat_screen.dart
│   └── signup_screen.dart
├── widgets/
│   ├── message_bubble.dart
│   └── user_image_picker.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   └── notification_service.dart
```

---

## ✅ To-Do

- [x] User authentication
- [x] Real-time messaging
- [x] Push notifications
- [x] Store user data in Firestore
- [x] Beautiful UI

---

## 📬 Feedback

Feel free to open issues or submit pull requests! Feedback is always welcome to make **We Chat** better.

---

## 📄 License

This project is open source under the [MIT License](LICENSE).
