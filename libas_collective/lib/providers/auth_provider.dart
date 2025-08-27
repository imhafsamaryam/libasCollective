import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/models/user_model.dart';
import 'package:store_app/services/auth_service.dart';
import 'package:store_app/services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  UserModel? _userData;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        loadUserData(user.uid);
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Future<void> loadUserData(String uid) async {
    try {
      _userData = await _firestoreService.getUser(uid);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load user data $e';
      notifyListeners();
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerWithEmail(
      String email, String password, String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user =
          await _authService.registerWithEmail(email, password, displayName);
      final token = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $token");
      if (user != null) {
        // Create user document in Firestore
        final userModel = UserModel(
          uid: user.uid,
          email: user.email!,
          displayName: displayName,
          photoUrl: user.photoURL,
          fcmToken: token!,
          createdAt: DateTime.now(),
        );
        await _firestoreService.saveUser(userModel);
        await loadUserData(user.uid); // Load the user data after registration

        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        // Check if user document exists, if not create one
        try {
          await _firestoreService.getUser(user.uid);
        } catch (e) {
          final token = await FirebaseMessaging.instance.getToken();
          print("FCM Token: $token");
          // User doesn't exist, create new document
          final userModel = UserModel(
              uid: user.uid,
              email: user.email!,
              displayName: user.displayName,
              photoUrl: user.photoURL,
              createdAt: DateTime.now(),
              fcmToken: token!);
          await _firestoreService.saveUser(userModel);
        }
        await loadUserData(user.uid); // Load the user data after Google sign-in

        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _userData = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
