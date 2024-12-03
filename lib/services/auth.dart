import 'package:cloud_firestore/cloud_firestore.dart';
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

      // Call to create user document in Firestore
      if (user != null) {
        await _createUserInDatabase(user.id);
      }

      return user;
    } catch (e) {
      print("Error registering user: $e");
      return null; // Optionally, return a specific error
    }
  }

  Future<void> _createUserInDatabase(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'favoritePapers': [],
      });
    } catch (e) {
      print("Error creating user document: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
