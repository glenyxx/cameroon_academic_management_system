import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../local/hive_setup.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up with Email & Password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phoneNumber,
    String? schoolName,
    String? className,
    List<String> subjects = const [],
    String language = 'en',
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create user model
        final userModel = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          role: role,
          phoneNumber: phoneNumber,
          schoolName: schoolName,
          className: className,
          subjects: subjects,
          language: language,
          createdAt: DateTime.now(),
        );

        // Save to Firestore
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toJson());

        // Save to local Hive
        final userBox = HiveSetup.getUserBox();
        await userBox.put('current_user', userModel.toJson());

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An error occurred during sign up: $e';
    }
  }

  // Sign In with Email & Password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Fetch user data from Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          final userModel = UserModel.fromJson(userDoc.data()!);

          // Save to local Hive
          final userBox = HiveSetup.getUserBox();
          await userBox.put('current_user', userModel.toJson());

          return userModel;
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An error occurred during sign in: $e';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();

      // Clear local data
      await HiveSetup.clearAllData();
    } catch (e) {
      throw 'An error occurred during sign out: $e';
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An error occurred while sending reset email: $e';
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Try to get from local first (offline support)
      final userBox = HiveSetup.getUserBox();
      final localUserData = userBox.get('current_user');

      if (localUserData != null) {
        return UserModel.fromJson(Map<String, dynamic>.from(localUserData));
      }

      // If not in local, fetch from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final userModel = UserModel.fromJson(userDoc.data()!);

        // Save to local
        await userBox.put('current_user', userModel.toJson());

        return userModel;
      }

      return null;
    } catch (e) {
      throw 'An error occurred while fetching user data: $e';
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      // Update in Firestore
      await _firestore
          .collection('users')
          .doc(updatedUser.id)
          .update(updatedUser.toJson());

      // Update in local Hive
      final userBox = HiveSetup.getUserBox();
      await userBox.put('current_user', updatedUser.toJson());
    } catch (e) {
      throw 'An error occurred while updating profile: $e';
    }
  }

  // Handle Firebase Auth Exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'An authentication error occurred: ${e.message}';
    }
  }
}