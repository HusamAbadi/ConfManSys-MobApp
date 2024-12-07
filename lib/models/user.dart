import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String username;
  final List<String> favoritePapers;

  AppUser({
    required this.id,
    required this.username,
    required this.favoritePapers,
  });

  // Factory method to create a AppUser from Firestore document
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      username: data['username'] ?? 'Guest User',
      favoritePapers: List<String>.from(data['favoritePapers'] ?? []),
    );
  }

  // Convert user to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'favoritePapers': favoritePapers,
    };
  }
}
