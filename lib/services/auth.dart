import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_management_system/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null
        ? AppUser(
            id: user.uid,
            username: '',
            favoritePapers: [],
            reports: [],
          )
        : null;
  }

  Stream<AppUser?> get userStream {
    return _auth.authStateChanges().asyncMap((User? user) async {
      if (user != null) {
        try {
          DocumentSnapshot doc =
              await _firestore.collection('users').doc(user.uid).get();
          return AppUser.fromFirestore(doc);
        } catch (e) {
          return AppUser(
            id: user.uid,
            username: 'Guest User',
            favoritePapers: [],
            reports: [],
          );
        }
      }
      return null;
    });
  }

  Future<AppUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      if (user != null) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': 'Guest User',
          'favoritePapers': [],
          'reports': [],
        });
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user != null
          ? _firestore
              .collection('users')
              .doc(user.uid)
              .get()
              .then((doc) => AppUser.fromFirestore(doc))
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<AppUser?> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'favoritePapers': [],
          'reports': [],
        });

        return AppUser(
          id: user.uid,
          username: username,
          favoritePapers: [],
          reports: [],
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
