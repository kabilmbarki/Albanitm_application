# Albanitm - Agricultural Monitoring and Technician Connection Platform

Albanitm is a Flutter-based mobile application designed to monitor agricultural conditions and connect farmers with agricultural technicians. The app provides real-time monitoring of environmental conditions and facilitates communication between farmers and agricultural experts.

## 🌟 Features

- **Real-time Monitoring**: Track temperature and humidity data with interactive charts
- **Technician Connection**: Find and chat with agricultural technicians
- **User Authentication**: Secure sign-in and sign-up for both farmers and technicians
- **Profile Management**: Update and manage user profiles
- **Push Notifications**: Stay updated with real-time alerts
- **Data Visualization**: View historical data with interactive line charts

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (compatible with Flutter version)
- Firebase account (for backend services)
- Android Studio / Xcode (for running the app on emulator/device)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/albanitm.git
   cd albanitm
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Create a new Firebase project
   - Add Android/iOS apps to your Firebase project
   - Download and add the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screens

- **Welcome Screen**: Choose between farmer and technician login
- **Authentication**: Sign in/Sign up screens for both user types
- **Home Dashboard**: View real-time sensor data and charts
- **Technicians List**: Browse and connect with agricultural technicians
- **Chat**: Communicate with technicians directly in the app
- **Profile**: Manage your account information

## 🔧 Dependencies

- `firebase_core`: ^3.14.0
- `firebase_auth`: ^5.6.0
- `firebase_database`: ^11.3.7
- `cloud_firestore`: ^5.6.9
- `firebase_messaging`: ^15.2.7
- `flutter_local_notifications`: ^19.3.0
- `firebase_storage`: ^12.4.7
- `fl_chart`: ^1.0.0
- `font_awesome_flutter`: ^10.1.0
- `image_picker`: ^1.1.1

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── welcome.dart              # Welcome screen
├── signIn.dart               # User sign-in
├── signUp.dart               # User registration
├── home.dart                 # Main dashboard
├── technicians.dart          # Technician listing
├── chat.dart                 # Chat functionality
├── profile.dart              # User profile
├── notification_service.dart # Notification handling
├── models/
│   └── technician.dart      # Technician data model
└── technician/
    ├── chatpage.dart        # Technician chat interface
    ├── signin.dart           # Technician sign-in
    ├── signup.dart          # Technician registration
    └── technicianprofile.dart # Technician profile
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✉️ Contact

Your Name - [@your_twitter](https://twitter.com/your_twitter) - your.email@example.com

Project Link: [https://github.com/yourusername/albanitm](https://github.com/yourusername/albanitm)
