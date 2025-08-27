# Libas Collective E-Commerce App

A simple e-commerce Flutter application featuring user authentication, product listing, product details, cart functionality, user profiles, push notifications, and Stripe payment integration. This project uses Firebase for backend services.

---

## Features

1. **User Authentication**

   - Firebase Authentication support.
   - Email & password authentication.
   - Google Sign-In support.

2. **Product Listing**

   - Fetch product data from Firestore.
   - Display products in a list using `cached_network_image` for efficient image loading.

3. **Product Details**

   - Detailed product information page.
   - Add products to the cart.

4. **Cart Functionality**

   - Add, remove, and update product quantities in the cart.

5. **User Profile**

   - View and update user profile information.
   - User data stored and retrieved from Firestore.

6. **Push Notifications**

   - Firebase Cloud Messaging (FCM) integration.

7. **Payment Integration**
   - Stripe payment integration.
   - Users can checkout and pay for products in their cart.

---

## Prerequisites

- Flutter = 3.35.2
- Dart = 3.9.0
- jdk Temurin-21.0.8+9
- Android Studio / VS Code
- Firebase Project
- Stripe Account
- Physical device

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/imhafsamaryam/libasCollective.git
cd libas_collective_app
flutter pub get
dart run build_runner build
```

### 2. Setup firebase

Go to Firebase Console, create a new project.

Enable Authentication (Email/Password + Google Sign-In).

Enable Firestore Database and create collections for products.

Enable Firebase Cloud Messaging for push notifications.

Add your Android and iOS apps to the Firebase project and download the google-services.json (Android) and GoogleService-Info.plist (iOS) files.

Place them in the respective directories:

android/app/google-services.json

ios/Runner/GoogleService-Info.plist

### 3. Configure Stripe

Create a Stripe account and get your Publishable Key and Secret Key.

Add your Stripe keys to lib/utils/constants.dart:

or follow the documentation from flutter_stripe pub package.

class AppConstants {
static const stripePublishableKey = 'your_publishable_key';
static const stripeSecretKey = 'your_secret_key';
}

### 4. Run the App

```bash

flutter run

```
