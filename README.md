# Cronos - Administrator App for iOS

Cronos is a native iOS application designed for administrators to efficiently manage products and stores within a centralized e-commerce platform. It leverages SwiftUI for a modern, intuitive interface and integrates advanced backend technologies to ensure seamless operation and scalability.

## Features

### Product Management
- Create, read, update, and delete (CRUD) operations for products.
- Maintain centralized control of catalog data to ensure consistency.

### Store Management
- Manage store profiles, including updates and deactivations.
- Synchronize changes across all dependent systems in real-time.

### Real-Time Communication
- Integrated with Firebase Firestore for instant messaging capabilities.
- Monitor and manage interactions between stores and customers.

### Security
- API Key-based authentication for secure access.
- Encrypted storage of sensitive data for robust protection.

### Scalability and Maintainability
- Implements Clean Architecture and MVVM patterns.
- Ensures ease of scaling and efficient code management.

## Technologies Used

- **Frontend:** SwiftUI for declarative UI design.
- **Backend:** Ktor server for handling operations and secure communications.
- **Database:** MongoDB for scalable and reliable data storage.
- **Messaging:** Firebase Firestore for real-time communication.

## Getting Started

### Prerequisites
- Xcode 13 or later.
- Swift 5.5 or later.
- Firebase account for integration.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ldgomm/cronos-ios.git
   ```
2. Navigate to the project directory:
   ```bash
   cd cronos-ios
   ```
3. Install dependencies using Swift Package Manager:
   - Open the project in Xcode.
   - Go to `File > Add Packages`.
   - Add the required packages as specified in the documentation.

### Configuration
1. Set up Firebase:
   - Download your `GoogleService-Info.plist` file from the Firebase Console.
   - Add it to the project root in Xcode.
2. Configure API Keys in the `Environment` file.

### Running the App
1. Build and run the app on your simulator or device:
   ```bash
   Command + R
   ```

## Contributing

We welcome contributions! To contribute:
1. Fork the repository.
2. Create a new branch for your feature or bugfix.
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes.
   ```bash
   git commit -m "Description of your changes"
   ```
4. Push to your fork.
   ```bash
   git push origin feature-name
   ```
5. Submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or support, please reach out to:
- **Email:** admin@cronosapp.com
- **GitHub Issues:** [Issue Tracker](https://github.com/yourusername/cronos-ios/issues)
