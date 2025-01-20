import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_management_system/models/user.dart';
import 'package:conference_management_system/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _userFromFirebaseUser(User? user, {String username = ''}) {
    return user != null
        ? AppUser(
            id: user.uid,
            username: username, // Use the provided username
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
          if (doc.exists) {
            String username = doc.get('username');
            return AppUser.fromFirestore(doc);
          } else {
            // If the document doesn't exist, create one with default values
            await _firestore.collection('users').doc(user.uid).set({
              'username': '',
              'favoritePapers': [],
              'reports': [],
            });
            return AppUser(
              id: user.uid,
              username: '',
              favoritePapers: [],
              reports: [],
            );
          }
        } catch (e) {
          return AppUser(
            id: user.uid,
            username: '',
            favoritePapers: [],
            reports: [],
          );
        }
      }
      return null;
    });
  }

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Fetch the user document from Firestore
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          // Return AppUser using the Firestore document data
          return AppUser.fromFirestore(doc);
        }
        // else {
        //   // If the document doesn't exist, create one with default values
        //   await _firestore.collection('users').doc(user.uid).set({
        //     'username': '',
        //     'favoritePapers': [],
        //     'reports': [],
        //   });
        //   return _userFromFirebaseUser(user);
        // }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<AppUser?> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password, username: username);
      User? user = result.user;

      if (user != null) {
        // Create user document in Firestore
        try {
          await _firestore.collection('users').doc(user.uid).set({
            'username': username,
            'favoritePapers': [],
            'reports': [],
          });

          // Return the AppUser object with the provided username
          return AppUser(
            id: user.uid,
            username: username,
            favoritePapers: [],
            reports: [],
          );
        } catch (e) {
          print('Error creating user document in Firestore: $e');
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Error during user registration: $e');
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
