import 'package:conference_management_system/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(id: user.uid, favoritePapers: []) : null;
  }

  Stream<AppUser?> get userStream {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<AppUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      return null;
    }
  }

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      return null; // Consider returning specific error messages
    }
  }

  Future<AppUser?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      AppUser? user = _userFromFirebaseUser(result.user);

      // If you want to save additional user data to Firestore after registration
      if (user != null) {
        await _createUserInDatabase(
            user.id); // Call to method that creates a user in the database
      }

      return user;
    } catch (e) {
      return null; // Consider returning specific error messages
    }
  }

  Future<void> _createUserInDatabase(String uid) async {
    // Example of adding user data to Firestore
    // await DatabaseService(uid: uid).addUserData({ 'favoritePapers': [] });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
